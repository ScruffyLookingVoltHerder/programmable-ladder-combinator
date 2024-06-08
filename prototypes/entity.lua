
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
    collision_mask = {},
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
    name = "brick-PLC",
    picture = brick_processor_image,
    minable = { mining_time = 1, result = "brick-PLC" },
    render_layer = 'floor-mechanics',
    max_health = 250,
    icons = {
        { icon_size = 32, icon = "__programmable-ladder-combinator__/graphics/icons/BrickPLC.png" }
    },
    collision_box = { { -0.45, -0.45 }, { 0.45, 0.45 } },
    selection_box = { { -0.6, -0.6 }, { 0.6, 0.6 } },
    selection_priority = 60,
    collision_mask = { "floor-layer", "object-layer", "water-tile" },
    flags = { "placeable-neutral", "player-creation" }
}
})

