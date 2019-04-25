local dumper = dofile 'dumper.lua'

local dump = dumper.dump
local idump = dumper.idump
local tdump = dumper.tdump
local bdump = dumper.bdump

--dumper.setoutput(nil)

local t = setmetatable({}, getmetatable(''))

-- dump
assert(dump('hello world') == 'hello world')
assert(dump(true) == 'true')
assert(dump(false) == 'false')
assert(dump(nil) == 'nil')
assert(dump(0) == '0')
assert(dump(0.5) == '0.5')
assert(dump({}) == '{}')
assert(dump({1,2}) == '{ 1, 2 }')
assert(dump({a=1}) == [[{
  a = 1
}]])
assert(dump({1,a=1}) == [[{ 1,
  a = 1
}]])
assert(dump(t) == '{}')
assert(dump('s',0,false,nil) == 's\t0\tfalse\tnil')

-- idump
assert(idump('hello world') == '"hello world"')
assert(idump(true) == 'true')
assert(idump(false) == 'false')
assert(idump(nil) == 'nil')
assert(idump(0) == '0')
assert(idump(0.5) == '0.5')
assert(idump({}) == '{}')
assert(idump({1,2}) == '{ 1, 2 }')
assert(idump({a=1}) == [[{
  a = 1
}]])
assert(idump({1,a=1}) == [[{ 1,
  a = 1
}]])
assert(idump(t):match('{%s*<metatable>%s*=%s*{'))
assert(idump('s',0,false,nil) == '"s"\t0\tfalse\tnil')

-- tdump
tdump()
assert(tdump('test'):match('[%d+].[%d+] ms\ttest'))

-- bdump
assert(bdump('something'):match('something%s+stack traceback:'))