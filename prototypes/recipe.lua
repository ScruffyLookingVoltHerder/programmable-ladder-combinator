data:extend({
    {
        type = "recipe",
        name = "brick-PLC",
        enabled = "true",
        ingredients = 
        {
          {"decider-combinator",2},{"arithmetic-combinator",2},{"copper-cable",1},
        },
        result = "brick-PLC"
      },


      {
        type = "recipe",
        name = "modular-PLC",
        enabled = "true",
        ingredients = 
        {
          {"decider-combinator",8},{"arithmetic-combinator",8},{"electronic-circuit",4},
        },
        result = "modular-PLC"
      },



      {
        type = "recipe",
        name = "remote-io",
        enabled = "true",
        ingredients = 
        {
          {"constant-combinator",4},{"electronic-circuit",2}
        },
        result = "remote-io"
      },


      {
        type = "recipe",
        name = "fieldbus-adapter",
        enabled = "true",
        ingredients = 
        {
          {"constant-combinator",1},{"advanced-circuit",4}
        },
        result = "fieldbus-adapter"
      },

})