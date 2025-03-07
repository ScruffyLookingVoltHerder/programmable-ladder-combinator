function overwriteContent(originalTable,newContent,removeRef)
	if originalTable == nil then
		err("could not overwrite content of nil with new content: "..serpent.block(newContent))
		return
	end
	for k,d in pairs(newContent) do
		if d == removeRef then
			originalTable[k]=nil
		else
			originalTable[k]=d
		end
	end
end



local iopoint_sprite
iopoint_sprite = {
    count = 1,
    filename = "__programmable-ladder-combinator__/graphics/icons/invisible.png",
    width = 1,
    height = 1,
    direction_count = 1
}

--iopoint
data:extend({ {

    type = "lamp",
    name = "PLC-iopoint",
    collision_box = { { -0.1, -0.1 }, { 0.1, 0.1 } },
    collision_mask = {layers={}},
    selection_box = { { -0.1, -0.1 }, { 0.1, 0.1 } },
    selection_priority = 70,
    minable = nil,
    maximum_wire_distance = 9,
    max_health = 10,
    icon_size = 16,
    icon = "__programmable-ladder-combinator__/graphics/icons/iopoint.png",
    flags = { "placeable-off-grid", "placeable-neutral", "player-creation" },
    circuit_wire_max_distance = 9,

    picture_on = iopoint_sprite,
    picture_off = iopoint_sprite,
    energy_source = { type = "void" },
    energy_usage_per_tick = "1J"
}
})

local brick_processor_image = {
    north = {
        filename = "__programmable-ladder-combinator__/graphics/entity/BrickPLC.png",
        width = 128,
        height = 128,
        scale = 0.25
    },
    east = {
        filename = "__programmable-ladder-combinator__/graphics/entity/BrickPLC.png",
        width = 128,
        height = 128,
        scale = 0.25,
        x = 128
    },
    south = {
        filename = "__programmable-ladder-combinator__/graphics/entity/BrickPLC.png",
        width = 128,
        height = 128,
        scale = 0.25,
        x = 256
    },
    west = {
        filename = "__programmable-ladder-combinator__/graphics/entity/BrickPLC.png",
        width = 128,
        height = 128,
        scale = 0.25,
        x = 384
    }
}


data:extend({  {

    type = "simple-entity-with-owner",
    name = "PLC",
    picture = brick_processor_image,
    minable = { mining_time = 1, result = "PLC" },
    render_layer = 'floor-mechanics',
    max_health = 250,
    icons = {
        { icon_size = 32, icon = "__programmable-ladder-combinator__/graphics/icons/BrickPLC.png" }
    },
    collision_box = { { -0.45, -0.45 }, { 0.45, 0.45 } },
    selection_box = { { -0.6, -0.6 }, { 0.6, 0.6 } },
    selection_priority = 60,
    collision_mask = {layers = {item = true, meltable = true, object = true, player = true, water_tile = true, is_object = true, is_lower_object = true}},
    flags = { "placeable-neutral", "player-creation" }
}
})


local removeKey = "__REMOVE__"
local entity = table.deepcopy(data.raw["container"]["steel-chest"])
overwriteContent(entity, {
	name = "PLC-CONNECTION",
	collision_box = removeKey, -- {{0, 0}, {0, 0}},
	selection_box = removeKey, --{{-0.25, -0.25}, {0.25, 0.25}},
	collision_mask = {layers={}},
	order="a",
	circuit_wire_max_distance = 64,
	draw_circuit_wires = false,
	draw_copper_wires = false,
	flags = {
		"placeable-player",
		"placeable-off-grid",
		"not-on-map",
		"not-blueprintable",
		"hide-alt-info",
		"not-deconstructable",
		"not-upgradable",
		"not-rotatable"
	},
	picture = {
		filename = "__programmable-ladder-combinator__/graphics/entity/empty4x1.png",
		priority = "extra-high",
		width = 1,
		height = 1,
		shift = {0, 0}
	},
	circuit_connector_sprites = removeKey,
	fast_replaceable_group = removeKey,
}, removeKey)
entity.minable.result = nil
data:extend({	entity })
