local Event = require('__stdlib__/stdlib/event/event')
local brickplc = require(".control.brick-plc")
--test
function init_tables()
    --Create global tables
    global.Brick_PLCs = global.Brick_PLCs or {}
    global.Modular_PLCs = global.Modular_PLCs or {}
    global.Remote_IOs = global.Remote_IOs or {}
end


Event.on_init(function()
    init_tables()


  end)

 
