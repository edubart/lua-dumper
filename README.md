# Dumper
A small library for dumping lua variables quickly.
This library is typically used for quick debugging values
to the terminal where one would use `print` but want
more information about the value (like table content),
output to stderr by default (or other file handle) and
optionally time elapsed.

## Installation

```bash
luarocks install dumper
```

## Example Usage

Example using:

```lua
local dumper = require 'dumper'

local s, i, b, t = 'string', 1, true, {}

-- dumping
dumper.dump(s, i, b, t)
-- outputs: string  1       true    {}

-- inspected dumping
dumper.idump(s, i, b, t)
-- outputs: "string"        1       true    {}

-- timed dumping
dumper.tdump() -- reset time
for _=1,1000 do
  -- (do stuff)
end
dumper.tdump("for loop")
-- outputs: 0.050853 ms     for loop

-- import dump functions to _G and set default output to stdout
require 'dumper'.import(io.stdout)
dump('test')
-- outputs: test
```

Tipically I setup this in my .bashrc:
```bash
export LUA_INIT="require 'dumper'.import()"
```

This make `dumper` functions available as global variables
when running any lua script in your machine. Then in lua script
simply run `dump(something)` to debug lua values with nicer format.

## Documentation

### setoutput(output)
Set dumper output file handle. You can pass here a file handle like
`io.stdout`, `io.stderr` or a temporary file using `io.tmpfile()`.
If value is nil or false dump will not output to any file, instead
it will only return a formated string.

### dump(...)
Dump any value using `tostring` function except for tables that does not
have __tostring metamethod, in this case `inspect` library is used, however
metatables are filtered from inspect output. Returns the formated string.

### idump(...)
Dump any value using `inspect` library. Returns the formated string.

### tdump(...)
Dump any value using `dump` and printing the time elapsed since last call,
all calls resets the timer, calling with no values can be used to just
reset the timer. Returns the formated string plus the elapsed time
in nanoseconds.

### bdump(...)
Dump any value using `dump` and printing traceback. Returns the formated
string plus the traceback.

### import(output)
Import `dump`, `idump`, `bdump`, `tdump` functions to _G. Optionally
an optiona argument `output` specifies the default output when printing.
function dumper.import(out)

## License

MIT
