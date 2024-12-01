data:extend({
    {
        type = "technology",
        name = "PLCTech", 
        icon = "__programmable-ladder-combinator__/graphics/icons/PLCtech.png",
        icon_size = 32,
        effects =
        {
          {
              type = "unlock-recipe",
              recipe = "brick-PLC"
          },
        },
        prerequisites = {"circuit-network",},
        unit =
        {
          count = 100,
          ingredients =
          {
            {"automation-science-pack", 1},
            
          },
          time = 10
        }
    },

    {
      type = "technology",
      name = "FieldBusTech", 
      icon = "__programmable-ladder-combinator__/graphics/icons/PLCtech.png",
      icon_size = 32,
      effects =
      {
        {
            type = "unlock-recipe",
            recipe = "remote-io"
        },
        {
          type = "unlock-recipe",
          recipe = "modular-PLC"
      },
      },
      prerequisites = {"PLCTech",},
      unit =
      {
        count = 200,
        ingredients =
        {
          {"automation-science-pack", 1},
          {"logistic-science-pack", 1},
        },
        time = 10
      }
  },
  {
    type = "technology",
    name = "FieldBusAdapterTech", 
    icon = "__programmable-ladder-combinator__/graphics/icons/PLCtech.png",
    icon_size = 32,
    effects =
    {
      {
          type = "unlock-recipe",
          recipe = "fieldbus-adapter"
      },

    },
    prerequisites = {"PLCTech","FieldBusTech","advanced-circuit"},
    unit =
    {
      count = 150,
      ingredients =
      {
        {"automation-science-pack", 1},
        {"logistic-science-pack", 1},
        {"chemical-science-pack", 1},
      },
      time = 10
    }
},

})