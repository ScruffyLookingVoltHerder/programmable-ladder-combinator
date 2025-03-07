local Event = require('__stdlib2__/stdlib/event/event')
local PLCbuilder = require("PLCbuilder")
local PLCEditor = require("PLCEditor")
local UDT_Tags= require("UDT_Tags")
local filter="PLC"

local coord_1x1 = 0.285

--- @type MapPosition[]


function on_built(event)
PLCbuilder.initglobal()
  

    local player = nil
	if event.player_index then
	player = game.players[event.player_index]
    end

    local entity = event.created_entity or event.entity or event.destination

    local iogroup=PLCbuilder.create_iogroup(entity.position,entity.direction,entity.surface,entity.force)

  local PLC={}
  PLC.entity=entity
  PLC.iogroup=iogroup
  PLC.UDTs=table.deepcopy(UDT_Tags.builtin_UDTs)

  PLC.tags={}
  UDT_Tags.build_tag(PLC.tags,"IO","IOgroup","Built-in I/O",PLC.UDTs)

  local test=0


    --Add to Global Table
    storage.PLCs[entity.unit_number] = PLC


local test=0

   
end

function remove(event, create_ghosts)
  
  PLCbuilder.initglobal()
local entity=event.entity

local PLC=storage.PLCs[entity.unit_number]

PLCbuilder.remove_iogroup(PLC.iogroup, create_ghosts)

storage.PLCs[entity.unit_number]=nil



end


function entities_pre_mined(event)
remove(event,false)
end

function entities_died(event)
  remove(event,true)
end

function entities_rotate(event)


end

function tick(event)



local t1=0


if storage.PLCs then
for num, PLC in pairs(storage.PLCs) do

local input = PLC.iogroup.iopoints[1].grn_input_combinator




end
end
end

function gui_open(event)

  if event.entity == nil then return end
  entity = event.entity
 
  if event.entity.type ~= filter then return end


  
  
end


Event.register(defines.events.on_built_entity, on_built,Event.Filters.entity.name,filter)
Event.register(defines.events.on_robot_built_entity, on_built,Event.Filters.entity.name,filter)
Event.register(defines.events.script_raised_built, on_built,Event.Filters.entity.name,filter)
Event.register(defines.events.script_raised_revive, on_built,Event.Filters.entity.name,filter)
Event.register(defines.events.on_entity_cloned, on_built,Event.Filters.entity.name,filter)

Event.register(defines.events.on_robot_pre_mined, entities_pre_mined,Event.Filters.entity.name,filter)
Event.register(defines.events.on_pre_player_mined_item, entities_pre_mined,Event.Filters.entity.name,filter)

Event.register(defines.events.on_entity_died, entities_died,Event.Filters.entity.name,filter)
Event.register(defines.events.script_raised_destroy, entities_died,Event.Filters.entity.name,filter)

Event.register(defines.events.on_player_rotated_entity, entities_rotate,Event.Filters.entity.name,filter)

Event.register(defines.events.on_gui_opened, gui_open)
Event.register(defines.events.on_tick, tick)

Event.register("PLC-click", function(event)

  local player = game.players[event.player_index]
 
  local selected = player.selected

  if selected and selected.name== "PLC" and
  player.is_cursor_empty()  then

player.print("PLC clicked")

PLCEditor.open_editor(player, selected)

end
end)

