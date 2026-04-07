---
name: python
description: Style guide for writing Python code matching the user's personal conventions. Use when writing, reviewing, or modifying Python scripts and modules.
---

Write Python code following these conventions:

## Boilerplate

- Shebang: `#!/usr/bin/env python3` for executable scripts
- For uv-managed scripts with inline dependencies: `#!/usr/bin/env -S uv run --script`
- Target latest Python unless the project specifies otherwise

## Imports

- Standard library first, then third-party, then local — separated by a blank line before third-party
- Prefer specific imports (`from functools import cache`) over module imports when only one thing is used

## Naming

- Functions/methods: `snake_case` with verb prefixes (`get_`, `create_`, `find_`, `parse_`, `list_`, `describe_`)
- Private functions: leading underscore
- Dunder-prefixed for name-mangled privates in classes: `__profile_namer`
- Classes: `PascalCase`
- Constants: `UPPER_SNAKE_CASE`
- Variables: `snake_case`, single letters fine for loop vars (`i`, `k`, `m`)
- Exceptions: `PascalCase` with `Exception`/`Error` suffix

## Type Hints

- Optional — must use in libraries and complex signatures, in most scripts they can be avoided
- Prefer modern syntax: `list[str]`, `dict[str, int]`, `tuple[bytes]`, `X | None`

## Docstrings & Comments

- Docstrings are minimal — single-line triple quotes when used: `'''view the file in a pager'''`
- Most functions have no docstring — the name and code should be self-documenting
- Inline comments only for non-obvious logic, TODOs, or external references (URLs)

## Strings & Formatting

- Single quotes preferred for strings: `'hello'`, `'utf-8'` - unless running in `python3 -c $''`, in which case use double quotes
- f-strings for interpolation: `f'Creating {name}'`
- `%` formatting inside logging calls: `logging.info('Creating %s', name)`
- Raw strings for regex: `r'\[([^]]+)\]'`

## Error Handling

- Custom exceptions inherit from `Exception` — keep them simple:
  ```python
  class SocketClosedException(Exception): pass
  ```
- `raise Exception(...)` is fine for one-off errors in scripts
- Use `raise ... from e` to chain exceptions with context
- `assert` for internal invariant/precondition checks
- `NotImplementedError` for unhandled cases/branches and abstract methods
- Bare `except:` with logging and re-raise is acceptable for response hooks / middleware
- `BaseExceptionGroup` for collecting multiple errors:
  ```python
  if exceptions := [f.exception() for f in futures if f.exception()]:
      raise BaseExceptionGroup('failed', exceptions)
  ```
- Exit code 130 for `KeyboardInterrupt` (POSIX convention)

## Functions & Classes

- `@dataclass` for simple data containers; regular classes for behavior-heavy types:
- `@dataclass(kw_only=True, eq=False)` when keyword-only construction and identity semantics are needed
- `Enum` for status codes and protocol constants:
- `@classmethod` for factory methods (`from_args`, `from_str`, `from_uri`)
- `@staticmethod` for methods that don't need instance state
- `@cache` liberally for memoization of expensive calls, use this as much as possible to avoid writing own memo/state in code
- `@contextlib.contextmanager` for resource lifecycle management
- `__getattr__` for dynamic method dispatch and lazy module wrappers
- `partial` from functools for creating function aliases, in thread code, etc
  ```python
  log = partial(print, file=sys.stderr)
  ```
- `lambda` for simple inline callbacks
- Abstract base classes using `NotImplementedError`:
  ```python
  def user_status(self, user) -> Status:
      raise NotImplementedError
  ```

## Generators & Comprehensions

- Use generators as much as possible, instead of making lists and returning in a function
- List/dict/set comprehensions freely

## Collections

- `defaultdict` when accumulating into groups or building lookup tables

## JSON

- When dumping JSON that contains `datetime` objects (e.g., from AWS responses), use a custom default handler:
  ```python
  def json_dumper(x):
      if isinstance(x, datetime.datetime):
          return x.timestamp()
      return json.JSONEncoder().default(x)

  print(json.dumps(summary, default=json_dumper))
  ```

## Modern Python

- Walrus operator freely
- `ExceptionGroup` / `BaseExceptionGroup` for multiple errors
- `match`/`case` where appropriate
- `pathlib.Path` preferred over `os.path`
- Default handling with `or`: `assignees = assignees or []`
- Dictionary unpacking: `data = {'title': title, **kwargs}`

## Requests

- For larger scripts, or ones which wrap APIs, use a module-level `requests.Session()` for connection reuse
- Attach a response hook to handle HTTP errors globally instead of checking each response:
  ```python
  SESSION = requests.Session()

  def response_hook(response, *args, **kwargs):
      try:
          logging.debug('Making %s request to: %s with body: %r', response.request.method, response.request.url, response.request.body)
          response.raise_for_status()
      except:
          logging.error('Failed %s request to %s', response.request.method, response.request.url)
          logging.error('%s', response.text)
          raise

  SESSION.hooks = {'response': response_hook}
  ```
- Call `SESSION.get(...)`, `SESSION.post(...)` etc. without per-call error checking

## Async

- `asyncio` for concurrent I/O — `async`/`await` with `asyncio.gather` for parallelism

## CLI Scripts

- `argparse` with subparsers for multi-command tools
- Entry point pattern:
  ```python
  if __name__ == '__main__':
      try:
          sys.exit(main())
      except KeyboardInterrupt:
          sys.exit(130)
  ```
- Add `BrokenPipeError` handling when output may be piped
- Log level as CLI argument: `--log` with choices `debug`, `info`, `warning`, `error`, `critical`
- Validation after parsing with `parser.error()` for complex constraints
- `parse_known_args` when passing extra args through to other commands
- Mutually exclusive groups for conflicting options
- `parser.set_defaults(callback=...)` for subcommand dispatch

## Logging

- Use the `logging` module — configure in `main()`:
  ```python
  parser.add_argument(
    '-l',
    '--log',
    choices=('debug', 'info', 'warning', 'error', 'critical'),
    default='info',
    help='Logging level (default: %(default)s)',
  )
  level = getattr(logging, args.log.upper())
  logging.basicConfig(level=level, format='%(levelname)s\t%(message)s')
  ```
- Or if no arg parsing, just do `logging.basicConfig(level=logging.INFO, format='%(levelname)s\t%(message)s')` at top of file
- `print(..., file=sys.stderr)` is also fine for simple scripts
- Use `%` style in log calls (not f-strings): `logging.info('Creating %s', name)`
- `logging.exception()` for caught exceptions with traceback
- Suppress noisy third-party loggers: `boto3.set_stream_logger('boto3', level=level + 1)`

## Concurrency

- `ThreadPoolExecutor` for parallel I/O operations
- If needed, use a `ScopedThreadPool`
```python
class ScopedThreadPool(ThreadPoolExecutor):
    """
    Wrapper around ThreadPoolExecutor that ensures all futures are completed before exiting the context
    """
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.futures = []

    def submit(self, *args, **kwargs):
        future = super().submit(*args, **kwargs)
        self.futures.append(future)
        return future

    def __exit__(self, *args, **kwargs):
        while True:
            done, pending = wait(self.futures)
            # may have futures that creates more futures
            if len(done) == len(self.futures):
                break

        result = super().__exit__(*args, **kwargs)
        if exceptions := [f.exception() for f in self.futures if f.exception()]:
            if len(exceptions) == 1:
                raise exceptions[0]
            raise BaseExceptionGroup('failed', exceptions)
        return result

with ScopedThreadPool() as executor:
    executor.submit(func)

with ScopedThreadPool() as executor:
    for region in {'ap-southeast-2', 'us-east-1'}:
        @executor.submit
        def job(region=region):
            print(region)
```


## Packaging

- `uv` as package manager for modern projects

## Testing

- `unittest.TestCase` with `test_*` methods when tests exist
- `self.assertEqual()`, `self.assertRaises()` for assertions
- Dynamic test generation with `setattr(TestClass, 'test_' + name, fn)` for parameterized tests
- Test fixtures in separate directories

## Style

- 4-space indentation
- Trailing commas in multi-line structures
- No strict line length — practical limit around 100-120 chars
- No linter config needed — follow these conventions directly
