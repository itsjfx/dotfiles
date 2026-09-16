#!/usr/bin/env python3
'''Vendor Bitbucket's pipelines schema locally, working around an upstream resolution bug.

The published schema at SCHEMA_URL has this shape:

    {"$id": ..., "$schema": "draft-07", "$ref": "#/components/schemas/pipelines_configuration",
     "components": {"schemas": {...}}}

Under draft-07, keywords sitting alongside $ref are ignored, so yaml-language-server strips the
root's siblings before resolving the ref - and `components` is a sibling. The ref target is deleted
before lookup, so the whole schema fails to resolve and you get no validation at all:

    $ref '/components/schemas/pipelines_configuration' in '...' cannot be resolved.

`definitions` and `$defs` are exempt from that stripping; `components` is not. Wrapping the root
$ref in an allOf leaves it with no siblings, so nothing gets stripped and the ref resolves.

Re-run this whenever Bitbucket ships new pipelines syntax.
'''

import json
import urllib.request
from pathlib import Path

SCHEMA_URL = 'https://api.bitbucket.org/schemas/pipelines-configuration'
OUTPUT = Path(__file__).parent / 'bitbucket-pipelines.json'


def fetch_schema(url):
    with urllib.request.urlopen(url, timeout=30) as response:
        return json.load(response)


def patch_schema(schema):
    patched = dict(schema)

    # the published $id claims a marketing page as the schema's identity; harmless but misleading,
    # since it is what gets reported as the source URI in resolution errors
    patched['$id'] = SCHEMA_URL

    if root_ref := patched.pop('$ref', None):
        patched['allOf'] = [{'$ref': root_ref}, *patched.get('allOf', [])]

    return patched


def main():
    schema = patch_schema(fetch_schema(SCHEMA_URL))
    OUTPUT.write_text(json.dumps(schema, indent=2, sort_keys=True) + '\n')
    definitions = schema.get('components', {}).get('schemas', {})
    print(f'wrote {OUTPUT} ({len(definitions)} definitions, root ref: {schema["allOf"][0]["$ref"]})')


if __name__ == '__main__':
    main()
