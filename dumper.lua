local inspect = require 'inspect'
local nanotime = require 'chronos'.nanotime

local dumper = {}
dumper.VERSION = "dumper 0.1.1"

local poutput = io.stderr
local function eprint(s)
  if poutput then
    poutput:write(s)
    poutput:write('\n')
    poutput:flush()
  end
  return s
end

local function hasmetamethod(t, method)
  local mt = getmetatable(t)
  if mt and mt[method] then return true end
  return false
end

local function inspect_remove_mts(item, path)
  if hasmetamethod(item, '__tostring') then return tostring(item) end
  if path[#path] ~= inspect.METATABLE then return item end
end

--- Set dumper output file handle. You can pass here a file handle like
-- `io.stdout`, `io.stderr` or a temporary file using `io.tmpfile()`.
-- If value is nil or false dump will not output to any file, instead
-- it will only return a formated string.
function dumper.setoutput(output)
  poutput = output
end

--- Dump any value using `tostring` function except for tables that does not
-- have __tostring metamethod, in this case `inspect` library is used, however
-- metatables are filtered from inspect output. Returns the formated string.
function dumper.dump(...)
  local args = {}
  for i=1,select('#', ...) do
    local v = select(i, ...)
    local vtype = type(v)
    local vstr
    if vtype == 'table' and not hasmetamethod(v, '__tostring') then
      vstr = inspect(v, {process = inspect_remove_mts})
    else
      vstr = tostring(v)
    end
    args[i] = vstr
  end
  return eprint(table.concat(args, '\t'))
end

--- Dump any value using `inspect` library. Returns the formated string.
function dumper.idump(...)
  local args = {}
  for i=1,select('#', ...) do
    local vstr = select(i, ...)
    args[i] = inspect(vstr)
  end
  return eprint(table.concat(args, '\t'))
end

local last = nanotime()

--- Dump any value using `dump` and printing the time elapsed since last call,
-- all calls resets the timer, calling with no values can be used to just
-- reset the timer. Returns the formated string plus the elapsed time
-- in nanoseconds.
function dumper.tdump(...)
  local now = nanotime()
  local elapsed = now - last
  last = now
  if select('#', ...) == 0 then return elapsed end
  local elapsedtext = string.format('%.6f ms', 1000*elapsed)
  return dumper.dump(elapsedtext, ...), elapsed
end

--- Dump any value using `dump` and printing traceback. Returns the formated
-- string plus the traceback.
function dumper.bdump(...)
  local tb = debug.traceback('', 2)
  local nargs = select('#', ...)
  local args = {...}
  args[nargs+1] = tb
  return dumper.dump(unpack(args, 1, nargs+1)), tb
end

--- Import `dump`, `idump` and `tdump` functions to _G. Optionally
-- an optiona argument `output` specifies the default output when printing.
function dumper.import(output)
  if out ~= nil then
    dumper.setoutput(output)
  end
  _G.dump = dumper.dump
  _G.idump = dumper.idump
  _G.tdump = dumper.tdump
  _G.bdump = dumper.bdump
end

setmetatable(dumper, { __call = function(v, ...)
  return dumper.dump(...)
end})

return dumper
