local Event = require('__stdlib2__/stdlib/event/event')
local brickplc = require(".control.plc")
--test
function init_tables()
    --Create global tables
    storage.Brick_PLCs = storage.Brick_PLCs or {}
    storage.Modular_PLCs = storage.Modular_PLCs or {}
    storage.Remote_IOs = storage.Remote_IOs or {}
end


Event.on_init(function()
    init_tables()


  end)

 
