# you must also add this to your ~/.aws/config
# and add to your PYTHONPATH
# e.g. PYTHONPATH=~/.aws/cli/plugins/:"$PYTHONPATH"

import os
import re
import sys
import time
import datetime
import itertools
import traceback

import botocore
import awscli.clidriver
from awscli.customizations.cloudformation.deployer import Deployer
from awscli.customizations.cloudformation.exceptions import CloudFormationCommandError

AWSCLI_VERSION = [int(x) for x in awscli.__version__.split('.')]

def awscli_initialize(cli):
    """ Entry point called by awscli """

def patch(obj, name):
    def _patch(fn, obj=obj, name=name):
        def fn(*args, fn=fn, original_fn=getattr(obj, name), **kwargs):
            return fn(original_fn, *args, **kwargs)
        setattr(obj, name, fn)
        return fn
    return _patch

def _print(*args, colour='', file=sys.stderr, end='\n', **kwargs):
    if os.isatty(file.fileno()) and colour:
        print(colour, end='', file=file)
        print(*args, end='', file=file, **kwargs)
        print('\x1b[0m', end=end, file=file)
    else:
        print(*args, end=end, file=file, **kwargs)

def columnate(rows):
    rows = list(rows)
    max_widths = [max(map(len, column)) for column in zip(*rows)]
    rows = [[c.ljust(w) for c, w in zip(r, max_widths)] for r in rows]
    for r in rows:
        r[-1] = r[-1].rstrip()
    return rows

if AWSCLI_VERSION[0] == 1:
    @patch(awscli.clidriver, 'write_exception')
    def write_exception(super, exc, outfile):
        if isinstance(exc, (botocore.exceptions.ClientError, botocore.exceptions.WaiterError, CloudFormationCommandError)):
            super(exc, outfile)
        else:
            traceback.print_exception(type(exc), exc, exc.__traceback__, file=outfile)

elif AWSCLI_VERSION[0] == 2:
    @patch(awscli.errorhandler.GeneralExceptionHandler, 'handle_exception')
    def handle_exception(super, self, exc, stdout, stderr):
        if isinstance(exc, (botocore.exceptions.ClientError, botocore.exceptions.WaiterError, CloudFormationCommandError)):
            return super(self, exc, stdout, stderr)
        else:
            traceback.print_exception(type(exc), exc, exc.__traceback__, file=stderr)
            return self.RC

@patch(botocore.client.BaseClient, '_make_api_call')
def _make_api_call(super, self, operation, params):
    service = self._service_model.service_name

    if service == 'cloudformation' and operation == 'ExecuteChangeSet':
        changes = self.describe_change_set(ChangeSetName=params['ChangeSetName'])
        stack_name = changes['StackName']
        changes = [c['ResourceChange'] for c in changes['Changes']]
        changes = columnate([
            {'Conditional': 'May replace', 'True': 'Replace'}.get(c.get('Replacement'), c['Action']),
            c['LogicalResourceId'],
            (('caused by: '+', '.join(d.get('CausingEntity', d['Target']['Attribute']+'.'+d['Target'].get('Name', '')) for d in c['Details'])) if c['Details'] else ''),
        ] for c in changes)

        _print('Changes for:', stack_name, colour='\x1b[1m')
        for row in changes:
            colour = {'Add': '\x1b[92m', 'Modify': '\x1b[92m', 'Remove': '\x1b[91m'}.get(row[0].strip(), '\x1b[93m')
            _print(*row, colour=colour, sep='  ')
        _print()

        os.environ.setdefault('AWS_EXECUTE_CHANGESET', '10')
        if os.environ['AWS_EXECUTE_CHANGESET'] in ('no', '0'):
            raise Exception(f'AWS_EXECUTE_CHANGESET={os.environ["AWS_EXECUTE_CHANGESET"]} given')
        elif os.environ['AWS_EXECUTE_CHANGESET'].lower() == 'ask':
            while True:
                response = input('Proceed (y/n): ')
                if response.lower() in ('y', 'yes'):
                    _print()
                    break
                if response.lower() in ('n', 'no'):
                    raise Exception('Abort')
        elif os.environ['AWS_EXECUTE_CHANGESET'].isnumeric():
            _print('Pausing for', os.environ['AWS_EXECUTE_CHANGESET'], 'seconds')
            time.sleep(int(os.environ['AWS_EXECUTE_CHANGESET']))

    return super(self, operation, params)

def events_from(client, stack_name, event_id=None):
    try:
        events = client.describe_stack_events(StackName=stack_name)['StackEvents']
    except botocore.exceptions.ClientError as e:
        if re.fullmatch(r'Stack .* does not exist', e.response['Error']['Message']):
            return ()
        raise

    index = 0
    for i, e in enumerate(events):
        if not event_id and e['PhysicalResourceId'] == e['StackId']:
            if e.get('ResourceStatusReason') == 'User Initiated':
                index = i + 1
            break
        elif e['EventId'] == event_id:
            index = i
            break
    return events[:index][::-1]

@patch(botocore.client.BaseClient, 'get_waiter')
def get_waiter(super, self, name):
    waiter = super(self, name)
    service = self._service_model.service_name
    client = self

    if service == 'cloudformation' and name in ('stack_create_complete', 'stack_update_complete', 'stack_import_complete', 'stack_delete_complete', 'stack_rollback_complete'):
        @patch(waiter, 'wait')
        def wait(super, *args, **kwargs):
            ##### execute change
            waiter.started = False
            waiter.last_event = None
            waiter.stack_id = kwargs['StackName']
            found = False
            for page in client.get_paginator('list_stacks').paginate():
                for stack in page['StackSummaries']:
                    if stack['StackName'] == kwargs['StackName']:
                        waiter.stack_id = stack['StackId']
                        found = True
                        break
                if found:
                    break
            return super(*args, **kwargs)

        @patch(waiter, '_operation_method')
        def _operation_method(super, *args, **kwargs):
            ##### dump events
            if not waiter.started:
                _print('Events for: ', kwargs['StackName'], colour='\x1b[1m')
                waiter.started = True
            events = events_from(client, waiter.stack_id, waiter.last_event)
            waiter.last_event = events[-1]['EventId'] if events else waiter.last_event

            rows = columnate([
                e['Timestamp'].rpartition('T')[2],
                e['ResourceStatus'].ljust(27),
                e['LogicalResourceId'],
                e.get('ResourceStatusReason', ''),
            ] for e in events)

            colours = {
                'ROLLBACK_FAILED': '\x1b[91m',
                'ROLLBACK_IN_PROGRESS': '\x1b[91m',
                'FAILED': '\x1b[91m',
                'ROLLBACK': '\x1b[95m',
                'IN_PROGRESS': '\x1b[93m',
                # 'SKIPPED': '\x1b[94m',
                'COMPLETE': '\x1b[92m',
            }
            for row, e in zip(rows, events):
                colour = ''
                for k, v in colours.items():
                    if k in e['ResourceStatus']:
                        colour += v
                        break
                if e['LogicalResourceId'] == kwargs['StackName']:
                    colour += '\x1b[1m'

                _print(row[0], end='')
                _print('', *row[1:], colour=colour, sep='  ')
            return super(*args, **kwargs)

    return waiter
