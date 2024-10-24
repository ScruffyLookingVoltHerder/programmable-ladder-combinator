data:extend({

    {
        type = "item-with-tags",
        name = "brick-PLC",
        icon = "__programmable-ladder-combinator__/graphics/icons/BrickPLC.png",
        icon_size = 32,
        subgroup = "circuit-network",
        stack_size = 100,
        place_result = "brick-PLC"
        },
        
})

data:extend({

    {
        type = "item",
        name = "modular-PLC",
        icon = "__programmable-ladder-combinator__/graphics/icons/ModularPLC.png",
        icon_size = 32,
        subgroup = "circuit-network",
        stack_size = 100,
        
        },
        
})

data:extend({

    {
        type = "item",
        name = "remote-io",
        icon = "__programmable-ladder-combinator__/graphics/icons/RemoteIO.png",
        icon_size = 32,
        subgroup = "circuit-network",
        stack_size = 100,
        
        },

    })

    data:extend({

        {
            type = "item",
            name = "fieldbus-adapter",
            icon = "__programmable-ladder-combinator__/graphics/icons/FieldbusAdapter.png",
            icon_size = 32,
            subgroup = "circuit-network",
            stack_size = 100,
            
            },
    
        })

        data:extend({
        {
            type = 'item',
            name = "PLC-iopoint",
            icon_size = 32,
            icon = "__programmable-ladder-combinator__/graphics/icons/invisible.png",
            subgroup = 'circuit-network',
            order = '[logistic]-b[elt]',
            place_result = "PLC-iopoint",
            stack_size = 50,
            flags = { "hidden", "hide-from-bonus-gui" }
        },
    })

    data:extend({
        {
            type = 'item',
            name = "PLC-event-token",
            icon_size = 6,
            icon = "__programmable-ladder-combinator__/graphics/icons/iopoint.png",
            subgroup = 'circuit-network',
            order = '[logistic]-b[elt]',
            place_result = "PLC-iopoint",
            stack_size = 50,
            flags = { "hidden", "hide-from-bonus-gui" }
        },
    })