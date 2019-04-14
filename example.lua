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
