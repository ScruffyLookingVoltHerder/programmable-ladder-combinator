data:extend({
    {
        type = "recipe",
        name = "PLC",
        enabled = false,
        ingredients = 
        {
          {type = "item", name = "decider-combinator", amount = 2},
          {type = "item", name = "arithmetic-combinator", amount = 2},
          {type = "item", name = "copper-cable", amount = 4},
        },
         results = {{type = "item", name = "PLC", amount = 1}} 
      },


      {
        type = "recipe",
        name = "remote-io",
        enabled = false,
        ingredients = 
        {
          {type = "item", name = "constant-combinator", amount = 4},
          {type = "item", name = "decider-combinator", amount = 4},
        },
        results = {{type = "item", name = "remote-io", amount = 1}} 
      },


      {
        type = "recipe",
        name = "fieldbus-adapter",
        enabled = false,
        ingredients = 
        {
          {type = "item", name = "constant-combinator", amount = 1},
          {type = "item", name = "advanced-circuit", amount = 4},
          
        },
        results ={{type = "item", name = "fieldbus-adapter", amount = 1}}  
      },

})