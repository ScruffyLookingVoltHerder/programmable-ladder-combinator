require("util")
local coord_1x1 = 0.285

local PLCbuilder = {}

function PLCbuilder.spiral(n)
 local k=math.ceil((math.sqrt(n)-1)/2)
 local t=2*k+1
 local m=t^2 
 local t=t-1
  if n>=m-t then return {x=k-(m-n),y=-k}        else m=m-t end
  if n>=m-t then return {x=-k,y=-k+(m-n)}       else m=m-t end
  if n>=m-t then return {x=-k+(m-n),y=k} else return {x=k,y=k-(m-n-t)} end
end


function PLCbuilder.create_iogroup(iogroup_pos, iogroup_dir,iogroup_surface, force)

local iogroup={}
iogroup.iopoints={}
iogroup.iopoints[1]={}
iogroup.iopoints[2]={}
iogroup.iopoints[3]={}
iogroup.iopoints[4]={}

local outer_points=PLCbuilder.create_outer_io_points(iogroup_pos,iogroup_dir,iogroup_surface,force)

iogroup.iopoints[1].outer_point=outer_points[1]
iogroup.iopoints[2].outer_point=outer_points[2]
iogroup.iopoints[3].outer_point=outer_points[3]
iogroup.iopoints[4].outer_point=outer_points[4]


storage.spirals[force.name] = storage.spirals[force.name] or {}
local spiral = storage.spirals[force.name]
local index=1
--test
repeat
index = index+1
until(spiral[index]==nil)

spiral[index]=iogroup

iogroup.force=force
iogroup.spiral_index=index

local spiral_pos=PLCbuilder.spiral(index)

spiral_pos.x=spiral_pos.x*9
spiral_pos.y=spiral_pos.y*9


local hidden_surface=PLCbuilder.plc_surface(force)

local bp_string="0eNrtWl1v2jAU/S9+nZnijxCCtKc97W3vFUIB3NZSPpgx3aqK/7577YRUHS2KC6OkUR84dezja58TxzfOE1nkW7U2urRk+kT0sio3ZHrzRDb6rsxyLCuzQpEpwSs2K+1oWRULXWa2MmRHiS5X6g+Zsh090CYz2t4Xyurl4VZ8N6NElVZbrXy37p/HebktFsoALW2oNkWW5yNtqnKkcrW0BjjXVa4IJetqAwRViR0D6Yh/jSl59GCHcb0g5XvSQq30tjhKKBpCcZhQBER5LEjZMchjMcb0LSHfmMQI+Cg2sqbK5wt1nz1oaAHVNhCQdn55jkHExhOU3OrcKvOy1D6uMZAHbewW/NLOnvPPSELJL7gA4UNhWZnCVYJw15lx4U7JN1ewRdc66zWGOkp+Z5QqwzsQRzv42ZV8Bn+HFBuHKsb6pZhRq6vQK6FvL3v/Khbt1wDQa6WNV4RMJ4fVa2nncHml91LearOx83b1PTJilS3vcREGBwDNvHEXmUaUVGsFg3ZRkC/Qstra9bYz98H5mXT0c9TTFejMfv5xKj+nnf3MPpWfWdTR0Gx4pF7Y0ox19fQnszTvZulTOPo1qURXqT7X05TJblJFZ5SqY25xwY0qGzaqcGUcqFfUL72uJxVkSWAu6BU7vhieSz8x6Of0mwTqx/qs39Wsl2lg5nrpu48Nu373vjc0URv0+xj6sbCs5NLy8UE+Jx8Py1R6Ld+1vATkIixXGO69D7F14TJMPjbcex9AvPg9p9+vHX6HHiuK/578fz+nCeKTqZSEfk7wykk9nwQfJPJdL9918tAErGeelafyrIiCz/Z6ajHBAnPEnllMnMxiPPSora8OE2FZbM8Mxk9mMBl6QNhXg8VheXbPDMZOZrDxOz7rfGX3LZLAzzrdXnFGyW9IyXC2bxhldEzZjDqU1IjTmPIapTWKsbRGYo8guUDI4aJ0FRHBXtbDGArjGkEhQgHdMOH6cTCuIaeMuVYOjmvYECCCiUQI3VDhO5BY6mkTiGniqBJoklJZI+7DT+Eyi/zoGGLeYInRYG34gXLpy6GIinoOEhxRjaELxK5OinhCBY4PqCnshhzGiYTHlsMcsfQYByb8wCCfZoiRB+mQp8YcebjH+0lzuB4/ZF7tDCftZGDVZjaATiIPjgt/qKjnlrcxCFQMniYtlr7+s9iwS88JntFWFWC49kNvSh7gnnUmi8c8lWkayyRN4kTsdn8Bl2c12g=="

local built=PLCbuilder.build_blueprint(bp_string,spiral_pos,force)

iogroup.hidden_parts=built


--combinators for connecting the points in the iogroup to the common change detection circuit
iogroup.change_combinator = PLCbuilder.find_CC(built,{"C","5"})
iogroup.iopoints[1].common_change_combinator = PLCbuilder.find_CC(built,{"C","1"})
iogroup.iopoints[2].common_change_combinator = PLCbuilder.find_CC(built,{"C","2"})
iogroup.iopoints[3].common_change_combinator = PLCbuilder.find_CC(built,{"C","3"})
iogroup.iopoints[4].common_change_combinator = PLCbuilder.find_CC(built,{"C","4"})


-- Combinators for detecting individual point changes
iogroup.iopoints[1].red_change_combinator = PLCbuilder.find_CC(built,{"I","1","red"})
iogroup.iopoints[1].grn_change_combinator = PLCbuilder.find_CC(built,{"I","1","green"})
iogroup.iopoints[2].red_change_combinator = PLCbuilder.find_CC(built,{"I","2","red"})
iogroup.iopoints[2].grn_change_combinator = PLCbuilder.find_CC(built,{"I","2","green"})
iogroup.iopoints[3].red_change_combinator = PLCbuilder.find_CC(built,{"I","3","red"})
iogroup.iopoints[3].grn_change_combinator = PLCbuilder.find_CC(built,{"I","3","green"})
iogroup.iopoints[4].red_change_combinator = PLCbuilder.find_CC(built,{"I","4","red"})
iogroup.iopoints[4].grn_change_combinator = PLCbuilder.find_CC(built,{"I","4","green"})


iogroup.iopoints[1].red_change_combinator = PLCbuilder.find_CC(built,{"I","1","red"})
iogroup.iopoints[1].grn_change_combinator = PLCbuilder.find_CC(built,{"I","1","green"})
iogroup.iopoints[2].red_change_combinator = PLCbuilder.find_CC(built,{"I","2","red"})
iogroup.iopoints[2].grn_change_combinator = PLCbuilder.find_CC(built,{"I","2","green"})
iogroup.iopoints[3].red_change_combinator = PLCbuilder.find_CC(built,{"I","3","red"})
iogroup.iopoints[3].grn_change_combinator = PLCbuilder.find_CC(built,{"I","3","green"})
iogroup.iopoints[4].red_change_combinator = PLCbuilder.find_CC(built,{"I","4","red"})
iogroup.iopoints[4].grn_change_combinator = PLCbuilder.find_CC(built,{"I","4","green"})


local test=0

return iogroup
end

function PLCbuilder.create_outer_io_points(iogroup_pos, iogroup_dir,iogroup_surface, force)

  local iopoint1_tmp,iopoint2_tmp,iopoint3_tmp,iopoint4_tmp

    -- Determine IOpoint positions
    local iopoints1_pos, iopoints2_pos,iopoints3_pos, iopoints4_pos
    if iogroup_dir == 0 then

        iopoints1_pos={iogroup_pos.x + coord_1x1, iogroup_pos.y - coord_1x1}
        iopoints2_pos={iogroup_pos.x + coord_1x1, iogroup_pos.y + coord_1x1}
        iopoints3_pos={iogroup_pos.x - coord_1x1, iogroup_pos.y + coord_1x1}
        iopoints4_pos={iogroup_pos.x - coord_1x1, iogroup_pos.y - coord_1x1}

    elseif iogroup_dir == 2 then 
        iopoints1_pos={iogroup_pos.x + coord_1x1, iogroup_pos.y + coord_1x1}
        iopoints2_pos={iogroup_pos.x - coord_1x1, iogroup_pos.y + coord_1x1}
        iopoints3_pos={iogroup_pos.x - coord_1x1, iogroup_pos.y - coord_1x1}
        iopoints4_pos={iogroup_pos.x + coord_1x1, iogroup_pos.y - coord_1x1}

    elseif iogroup_dir == 4 then
        iopoints1_pos={iogroup_pos.x - coord_1x1, iogroup_pos.y + coord_1x1}
        iopoints2_pos={iogroup_pos.x - coord_1x1, iogroup_pos.y - coord_1x1}
        iopoints3_pos={iogroup_pos.x + coord_1x1, iogroup_pos.y - coord_1x1}
        iopoints4_pos={iogroup_pos.x + coord_1x1, iogroup_pos.y + coord_1x1}

    elseif entity.direction == 6 then
        iopoints1_pos={iogroup_pos.x - coord_1x1, iogroup_pos.y - coord_1x1}
        iopoints2_pos={iogroup_pos.x + coord_1x1, iogroup_pos.y - coord_1x1}
        iopoints3_pos={iogroup_pos.x + coord_1x1, iogroup_pos.y + coord_1x1}
        iopoints4_pos={iogroup_pos.x - coord_1x1, iogroup_pos.y + coord_1x1}

    end

      --Get IOpoints from preexisting IOpoints or ghosts

      local iopoints_found =0
      local item0 = iogroup_surface.find_entities({iopoints1_pos,iopoints1_pos})
      for _,ghost in pairs (item0) do
        if ghost.valid then
          if ghost.name == "entity-ghost" then
            if ghost.ghost_name == "PLC-iopoint" then
              
              _,iopoint1_tmp = ghost.revive()              
            end
          elseif ghost.name == "PLC-iopoint" then
            iopoints_found = iopoints_found + 1
            iopoint1_tmp=ghost
          end
          end
       
      end

      local item1 = iogroup_surface.find_entities({iopoints2_pos,iopoints2_pos})
      for _,ghost in pairs (item1) do
        if ghost.valid then
          if ghost.name == "entity-ghost" then
            if ghost.ghost_name == "PLC-iopoint" then
              iogroup_surface.print("iopoint ghost found")
              _,iopoint2_tmp = ghost.revive()             
            end
          elseif ghost.name == "PLC-iopoint" then
            iopoints_found = iopoints_found + 1
            iopoint2_tmp=ghost
          end
          end

      end

      local item2 = iogroup_surface.find_entities({iopoints3_pos,iopoints3_pos})
      for _,ghost in pairs (item2) do
        if ghost.valid then
          if ghost.name == "entity-ghost" then
            if ghost.ghost_name == "PLC-iopoint" then
              iogroup_surface.print("iopoint ghost found")
              _,iopoint3_tmp = ghost.revive()              
            end
          elseif ghost.name == "PLC-iopoint" then
            iopoints_found = iopoints_found + 1
            iopoint3_tmp=ghost
          end
          end

      end

      local item3 = iogroup_surface.find_entities({iopoints4_pos,iopoints4_pos})
      for _,ghost in pairs (item3) do
        if ghost.valid then
          if ghost.name == "entity-ghost" then
            if ghost.ghost_name == "PLC-iopoint" then
              iogroup_surface.print("iopoint ghost found")
              _,iopoint4_tmp= ghost.revive()
            end
          elseif ghost.name == "PLC-iopoint" then
            iopoints_found = iopoints_found + 1
            iopoint4_tmp=ghost
          end
          end

      end
 
     

      --Create new IOpoints if no ghosts or existing ones found
      if iopoint1_tmp == nil then
    iopoint1_tmp = iogroup_surface.create_entity
    {
      name = "PLC-iopoint",
      position = iopoints1_pos,
      force = force
    }
    end

    if iopoint2_tmp == nil then
    iopoint2_tmp = iogroup_surface.create_entity
    {
      name = "PLC-iopoint",

      position = iopoints2_pos,
      force = force
    }
    end

if iopoint3_tmp == nil then
    iopoint3_tmp = iogroup_surface.create_entity
    {
      name = "PLC-iopoint",

      position = iopoints3_pos,
      force = force
    }
    end

    if iopoint4_tmp == nil then
    iopoint4_tmp = iogroup_surface.create_entity
    {
      name = "PLC-iopoint",

      position = iopoints4_pos,
      force = force
    }
    end


    --do not allow interaction with iopoints
    --Set IOpoint force to same force as the PLC. necessary for construction planning type mods.
    iopoint1_tmp.operable = false -- disable gui
    iopoint1_tmp.minable = false
    iopoint1_tmp.destructible = false
    iopoint1_tmp.force=force

    iopoint2_tmp.operable = false -- disable gui
    iopoint2_tmp.minable = false
    iopoint2_tmp.destructible = false
    iopoint2_tmp.force=force

    iopoint3_tmp.operable = false -- disable gui
    iopoint3_tmp.minable = false
    iopoint3_tmp.destructible = false
    iopoint3_tmp.force=force

    iopoint4_tmp.operable = false -- disable gui
    iopoint4_tmp.minable = false
    iopoint4_tmp.destructible = false
    iopoint4_tmp.force=force

    local iopoints={iopoint1_tmp,iopoint2_tmp,iopoint3_tmp,iopoint4_tmp}

return iopoints
end

function PLCbuilder.remove_iogroup(iogroup, create_ghosts)

   if iogroup==nil
    then
        return
    end

    if iogroup.iopoints[1].outer_point and iogroup.iopoints[1].outer_point.valid then
        if create_ghosts then
            iogroup.iopoints[1].outer_point.destructible = true
            iogroup.iopoints[1].outer_point.die()
        else
            iogroup.iopoints[1].outer_point.destroy()
        end
      end
      
      if iogroup.iopoints[2].outer_point and iogroup.iopoints[2].outer_point.valid then
        if create_ghosts then
            iogroup.iopoints[2].outer_point.destructible = true
          iogroup.iopoints[2].outer_point.die()
        else
            iogroup.iopoints[2].outer_point.destroy()
        end
      end
      
      if iogroup.iopoints[3].outer_point and iogroup.iopoints[3].outer_point.valid then
        if create_ghosts then
          iogroup.iopoints[3].outer_point.destructible = true
          iogroup.iopoints[3].outer_point.die()
        else
            iogroup.iopoints[3].outer_point.destroy()
        end
      end
      
      if iogroup.iopoints[4].outer_point and iogroup.iopoints[4].outer_point.valid then
        if create_ghosts then
            iogroup.iopoints[4].outer_point.destructible = true
            iogroup.iopoints[4].outer_point.die()
        else
            iogroup.iopoints[4].outer_point.destroy()
        end
      end


      local spiral = storage.spirals[iogroup.force.name]

      spiral[iogroup.spiral_index]=nil

      local test=0
      
end

function PLCbuilder.plc_surface(force)

   local surface_name='PLC-event-surface-'..force.name
   

    if game.surfaces[surface_name] then
        return game.surfaces[surface_name]
      end
    
      local surface = game.create_surface(surface_name,{width=1,height=1,peaceful_mode=true})
      --surface.generate_with_lab_tiles = true
      surface.always_day=true
      surface.peaceful_mode=true

     -- surface.request_to_generate_chunks({0,0},4)
     -- surface.force_generate_chunk_requests()

    
      local bp_string="0eNq1k9FugzAMRf8lz2EalCSCX6mqKlC3swShSkK7ruLf56QRq1a0rQ+DBw7Evr52wpU13QhHi8az+sqwHYxj9frKHB6M7sI3o3tgNXNj47z2OBg2cYZmB++szie+EAodtN5im4EBe7hkJA52r1u4yyymDWdgPHqEW8X4ctmasW/AkjRfqMzZcXAYkcqRTFZxdgmPKTj5JlH8SeInhdWsEAbjtfFZO/QNGu0H+yilXsRNjIBapRxvh27bwJs+ISVQlKPRYBzyPVP780Q305KT8jkn8v+cCP77Pj9OJrpRZGWH9laMKtAGNeN+D3br8IMU89f5WigsnzkRi9upnjgQJEAn9Exuw1TWOc95wfMNjyQTFeFOJBMJYpFIRqI8XsaMQCpRwVcxI5BKJIhChpzj5Lwq0yq5Qg89NfH163J2AutiC0IWVVlVolSVEmo1TZ8UQD/d"

      PLCbuilder.build_blueprint(bp_string,{x=0,y=0},force)

    
     return surface

end


function PLCbuilder.initglobal()
  storage.BrickPLCs = storage.Brick_PLCs or {}
  storage.Modular_PLCs = storage.Modular_PLCs or {}
  storage.Remote_IOs = storage.Remote_IOs or {}
  storage.spirals = storage.spirals or {}

end

function PLCbuilder.build_blueprint(bp_string,position,force)


  

  local surface_name='PLC-event-surface-'..force.name
  local surface =game.surfaces[surface_name]

  



  local inventory=game.create_inventory(1)
  local bp=inventory[1]
  bp.import_stack(bp_string)

  local entities=bp.get_blueprint_entities()

  local minx=entities[1].position.x
  local miny=entities[1].position.y
  local maxx=entities[1].position.x
  local maxy=entities[1].position.y


  for i,v in ipairs(entities) do 
    minx=math.min(minx,v.position.x)
    miny=math.min(miny,v.position.y)
    maxx=math.max(maxx,v.position.x)
    maxy=math.max(maxy,v.position.y)
    surface.set_chunk_generated_status({(v.position.x+position.x)/32,(v.position.y+position.y)/32}, defines.chunk_generated_status.entities)
  end

  minx=math.floor(minx)-5
  miny=math.floor(miny)-5
  maxx=math.ceil(maxx)+5
  maxy=math.ceil(maxy)+5

  local tiles = {}
	local area = {{minx+position.x,miny+position.y},{maxx+position.x,maxy+position.y}}

  
	for x=area[1][1],area[2][1]-1 do for y=area[1][2],area[2][2]-1 do
		surface.request_to_generate_chunks({x/32,y/32},4)
	end end
  surface.force_generate_chunk_requests()



	for x=area[1][1],area[2][1]-1 do for y=area[1][2],area[2][2]-1 do
		table.insert(tiles,{name="refined-concrete",position={x,y}})
	end end
	surface.set_tiles(tiles)




  local ghosts=bp.build_blueprint{
    surface=surface, force=force.name, position={position.x,position.y}, 
    force_build=true, skip_fog_of_war=false,
  }

local entities={}
  for i,ghost in ipairs(ghosts) do

      local collisions,entity=ghost.silent_revive({raise_revive=false})
      entities[i]=entity
    local test2=1
  end


  inventory.destroy()

  return entities
end

function PLCbuilder.find_CC(entities,signals)

  for i,entity in ipairs(entities) do

    local test=0
    if entity.name=="constant-combinator" then
    local filters=entity.get_control_behavior().sections[1].filters

    local cc_found=true
    for s, signal in ipairs(signals) do
      local signal_found = false
      for f, filter in ipairs(filters) do
        local signal_name="signal-"..signal
        if filter.value.name==signal_name then
          signal_found=true
        end
      end
      if signal_found ==false then
        cc_found=false
      end
    end
  
    if cc_found ==true then
      local section=entity.get_control_behavior().sections[1]
      section.filters={}
      return entity
    end

  end
  end

  return nil
end



return PLCbuilder