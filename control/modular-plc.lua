local Event = require('__stdlib__/stdlib/event/event')
local filter="modular%-ladder%-combinator"


function on_built(event)

    local player = nil
	if event.player_index then
	player = game.players[event.player_index]
    end

    player.print("test")

end

function entities_pre_mined(event)

    local player = nil
	if event.player_index then
		player = game.players[event.player_index]
    end

    player.print("goodbye, Player")

end

function entities_died(event)

end



function entities_rotate(event)


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

