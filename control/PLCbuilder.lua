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
iogroup.iopoint_0={}
iogroup.iopoint_1={}
iogroup.iopoint_2={}
iogroup.iopoint_3={}

local outer_points=PLCbuilder.create_outer_io_points(iogroup_pos,iogroup_dir,iogroup_surface,force)

iogroup.iopoint_0.outer_point=outer_points[1]
iogroup.iopoint_1.outer_point=outer_points[2]
iogroup.iopoint_2.outer_point=outer_points[3]
iogroup.iopoint_3.outer_point=outer_points[4]


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

spiral_pos.x=spiral_pos.x*7
spiral_pos.y=spiral_pos.y*7


local hidden_surface=PLCbuilder.plc_surface(force)

local bp_string="0eNqdU9FugzAM/Bc/h2kB2lKkfclUoQBeawkSlIRqFcq/Lwla1w5UrXtB2HHuzud4grobcdAkLZQTUKOkgfJ9AkNHKbqQs5cBoQSy2AMDKfoQ9djS2CfYYWM1NcmgOgTHgGSLn1Byd2CA0pIlnPFicKnk2NeofcEVyfSi6xLSSv5CYzAo4wGUDCo8aJK+bBhc5h/P5bVKf4Gi5Al4+Bw1orwlpBbKzB2cr5dIx1OtRh0UpQfHFqrSx/0tFWXfirKo6I6Bs5xt1liyKwtJg9r63BKZ3/fakp5bhTKPnVutuqrGkziT0uFSQ7oZyVb+rL0ifZA2tlrM8kzajj7zM4RYkbTKwmyssSK8CP4aon4QWthAA2/gnnGeB+dXLMifNPqRzynbrrm8+e8s/06x/WcXKwzxqfidiVtW3iwlgzNqEzHSgue7fborimK756lzX5m3PxY="

local built=PLCbuilder.build_blueprint(bp_string,spiral_pos,force)

local poles=PLCbuilder.buildPolesFromTo(iogroup_pos,built[2].position,hidden_surface,force)

PLCbuilder.connectWires(outer_points[1],poles[1])

PLCbuilder.connectWires(built[2],poles[#poles])

iogroup.iopoint_0.inserter=built[2]


local surface_name='PLC-event-surface-'..force.name
local surface =game.surfaces[surface_name]

fish1 = surface.create_entity
{
  name = "item-on-ground",
  position = {built[2].position.x,built[2].position.y+1},
  force = force,
  stack={name="raw-fish"}
}



local num = script.register_on_object_destroyed(fish1)

local test=1

iogroup_surface.print("fish: "..num)

return iogroup
end

function PLCbuilder.create_outer_io_points(iogroup_pos, iogroup_dir,iogroup_surface, force)

  local iopoint_0_tmp,iopoint_1_tmp,iopoint_2_tmp,iopoint_3_tmp

    -- Determine IOpoint positions
    local iopoint_0_pos, iopoint_1_pos,iopoint_2_pos, iopoint_3_pos
    if iogroup_dir == 0 then

        iopoint_0_pos={iogroup_pos.x + coord_1x1, iogroup_pos.y - coord_1x1}
        iopoint_1_pos={iogroup_pos.x + coord_1x1, iogroup_pos.y + coord_1x1}
        iopoint_2_pos={iogroup_pos.x - coord_1x1, iogroup_pos.y + coord_1x1}
        iopoint_3_pos={iogroup_pos.x - coord_1x1, iogroup_pos.y - coord_1x1}

    elseif iogroup_dir == 2 then 
        iopoint_0_pos={iogroup_pos.x + coord_1x1, iogroup_pos.y + coord_1x1}
        iopoint_1_pos={iogroup_pos.x - coord_1x1, iogroup_pos.y + coord_1x1}
        iopoint_2_pos={iogroup_pos.x - coord_1x1, iogroup_pos.y - coord_1x1}
        iopoint_3_pos={iogroup_pos.x + coord_1x1, iogroup_pos.y - coord_1x1}

    elseif iogroup_dir == 4 then
        iopoint_0_pos={iogroup_pos.x - coord_1x1, iogroup_pos.y + coord_1x1}
        iopoint_1_pos={iogroup_pos.x - coord_1x1, iogroup_pos.y - coord_1x1}
        iopoint_2_pos={iogroup_pos.x + coord_1x1, iogroup_pos.y - coord_1x1}
        iopoint_3_pos={iogroup_pos.x + coord_1x1, iogroup_pos.y + coord_1x1}

    elseif entity.direction == 6 then
        iopoint_0_pos={iogroup_pos.x - coord_1x1, iogroup_pos.y - coord_1x1}
        iopoint_1_pos={iogroup_pos.x + coord_1x1, iogroup_pos.y - coord_1x1}
        iopoint_2_pos={iogroup_pos.x + coord_1x1, iogroup_pos.y + coord_1x1}
        iopoint_3_pos={iogroup_pos.x - coord_1x1, iogroup_pos.y + coord_1x1}

    end

      --Get IOpoints from preexisting IOpoints or ghosts

      local iopoints_found =0
      local item0 = iogroup_surface.find_entities({iopoint_0_pos,iopoint_0_pos})
      for _,ghost in pairs (item0) do
        if ghost.valid then
          if ghost.name == "entity-ghost" then
            if ghost.ghost_name == "PLC-iopoint" then
              
              _,iopoint_0_tmp = ghost.revive()              
            end
          elseif ghost.name == "PLC-iopoint" then
            iopoints_found = iopoints_found + 1
            iopoint_0_tmp=ghost
          end
          end
       
      end

      local item1 = iogroup_surface.find_entities({iopoint_1_pos,iopoint_1_pos})
      for _,ghost in pairs (item1) do
        if ghost.valid then
          if ghost.name == "entity-ghost" then
            if ghost.ghost_name == "PLC-iopoint" then
              iogroup_surface.print("iopoint ghost found")
              _,iopoint_1_tmp = ghost.revive()             
            end
          elseif ghost.name == "PLC-iopoint" then
            iopoints_found = iopoints_found + 1
            iopoint_1_tmp=ghost
          end
          end

      end

      local item2 = iogroup_surface.find_entities({iopoint_2_pos,iopoint_2_pos})
      for _,ghost in pairs (item2) do
        if ghost.valid then
          if ghost.name == "entity-ghost" then
            if ghost.ghost_name == "PLC-iopoint" then
              iogroup_surface.print("iopoint ghost found")
              _,iopoint_2_tmp = ghost.revive()              
            end
          elseif ghost.name == "PLC-iopoint" then
            iopoints_found = iopoints_found + 1
            iopoint_2_tmp=ghost
          end
          end

      end

      local item3 = iogroup_surface.find_entities({iopoint_3_pos,iopoint_3_pos})
      for _,ghost in pairs (item3) do
        if ghost.valid then
          if ghost.name == "entity-ghost" then
            if ghost.ghost_name == "PLC-iopoint" then
              iogroup_surface.print("iopoint ghost found")
              _,iopoint_3_tmp= ghost.revive()
            end
          elseif ghost.name == "PLC-iopoint" then
            iopoints_found = iopoints_found + 1
            iopoint_3_tmp=ghost
          end
          end

      end
 
     

      --Create new IOpoints if no ghosts or existing ones found
      if iopoint_0_tmp == nil then
    iopoint_0_tmp = iogroup_surface.create_entity
    {
      name = "PLC-iopoint",
      position = iopoint_0_pos,
      force = force
    }
    end

    if iopoint_1_tmp == nil then
    iopoint_1_tmp = iogroup_surface.create_entity
    {
      name = "PLC-iopoint",

      position = iopoint_1_pos,
      force = force
    }
    end

if iopoint_2_tmp == nil then
    iopoint_2_tmp = iogroup_surface.create_entity
    {
      name = "PLC-iopoint",

      position = iopoint_2_pos,
      force = force
    }
    end

    if iopoint_3_tmp == nil then
    iopoint_3_tmp = iogroup_surface.create_entity
    {
      name = "PLC-iopoint",

      position = iopoint_3_pos,
      force = force
    }
    end


    --do not allow interaction with iopoints
    --Set IOpoint force to same force as the PLC. necessary for construction planning type mods.
    iopoint_0_tmp.operable = false -- disable gui
    iopoint_0_tmp.minable = false
    iopoint_0_tmp.destructible = false
    iopoint_0_tmp.force=force

    iopoint_1_tmp.operable = false -- disable gui
    iopoint_1_tmp.minable = false
    iopoint_1_tmp.destructible = false
    iopoint_1_tmp.force=force

    iopoint_2_tmp.operable = false -- disable gui
    iopoint_2_tmp.minable = false
    iopoint_2_tmp.destructible = false
    iopoint_2_tmp.force=force

    iopoint_3_tmp.operable = false -- disable gui
    iopoint_3_tmp.minable = false
    iopoint_3_tmp.destructible = false
    iopoint_3_tmp.force=force

    local iopoints={iopoint_0_tmp,iopoint_1_tmp,iopoint_2_tmp,iopoint_3_tmp}

return iopoints
end

function PLCbuilder.remove_iogroup(iogroup, create_ghosts)

   if iogroup==nil
    then
        return
    end

    if iogroup.iopoint_0.outer_point and iogroup.iopoint_0.outer_point.valid then
        if create_ghosts then
            iogroup.iopoint_0.outer_point.destructible = true
            iogroup.iopoint_0.outer_point.die()
        else
            iogroup.iopoint_0.outer_point.destroy()
        end
      end
      
      if iogroup.iopoint_1.outer_point and iogroup.iopoint_1.outer_point.valid then
        if create_ghosts then
            iogroup.iopoint_1.outer_point.destructible = true
          iogroup.iopoint_1.outer_point.die()
        else
            iogroup.iopoint_1.outer_point.destroy()
        end
      end
      
      if iogroup.iopoint_2.outer_point and iogroup.iopoint_2.outer_point.valid then
        if create_ghosts then
          iogroup.iopoint_2.outer_point.destructible = true
          iogroup.iopoint_2.outer_point.die()
        else
            iogroup.iopoint_2.outer_point.destroy()
        end
      end
      
      if iogroup.iopoint_3.outer_point and iogroup.iopoint_3.outer_point.valid then
        if create_ghosts then
            iogroup.iopoint_3.outer_point.destructible = true
            iogroup.iopoint_3.outer_point.die()
        else
            iogroup.iopoint_3.outer_point.destroy()
        end
      end


      local spiral = storage.spirals[iogroup.force.name]

      spiral[iogroup.spiral_index]=nil

      
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

    
      local bp_string="0eNqdktuOgyAQQP9lnrFRqq31V5qm8TK6kwgawM1aw7/vSBOzSbubbnligDkHhlmg6iccDWkHxQJUD9pCcV7AUqfLfl1z84hQADlUIECXao2wx9oZqiPUaLo54nw0bVkjeAGkG/yCIvEXAagdOcI7NATzVU+qQsMHNpzChiYVbdRx6JFl42A5edDrNRgY7XeZgPk+YY9G6j6qYTIrXYr04sWDQ/7T8ZciEdkzxf6Fqjx44mCJWdGQ4aywcxBQTW2L5mrpxsAk3sYTb/pu+V5/WvZm9X77H26I0EfFj7YT8InGBobMk/R4ksc8zw+nRHr/DTUv3Qc="

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

  

  surface.request_to_generate_chunks({position.x/32,position.y/32},4)
  surface.force_generate_chunk_requests()

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

  minx=math.floor(minx)
  miny=math.floor(miny)
  maxx=math.ceil(maxx)
  maxy=math.ceil(maxy)

  local tiles = {}
	local area = {{minx+position.x,miny+position.y},{maxx+position.x,maxy+position.y}}
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


PLCbuilder.buildPolesFromTo = function(pos1, pos2, surface, force)
	local poles = {}
	poles[1] = surface.create_entity{
		name="PLC-CONNECTION", position=pos1, force=force
	}
	
  poles[1].destructible = false
	poles[1].minable = false
	poles[1].operable = false
	
	local current = pos1
	local nr = 0
	local poleMaxD = 63 -- 64 is max wire distance, use 63 to make sure it always connects (number precision)
	while true do
		local dist = util.distance(current, pos2)

    
		if dist == 0 then break end
		
		local w = math.atan2(pos2["y"] - current["y"], pos2["x"] - current["x"])
		local step = math.min(poleMaxD, dist)
		current["x"] = current["x"] + math.cos(w)*step
		current["y"] = current["y"] + math.sin(w)*step
		
		local pole = surface.create_entity{
			name="PLC-CONNECTION", position=current, force=force
		}
    pole.destructible = false
    pole.minable = false
    pole.operable = false
    
		PLCbuilder.connectWires(poles[#poles], pole)


    
		table.insert(poles, pole)
		
		nr=nr+1
		if nr > 50 then break end
	end
	
	return poles
end

PLCbuilder.connectWires = function(entity, entity2)
	local b = entity.connect_neighbour{wire=defines.wire_type.red, target_entity=entity2}
	local b2 = entity.connect_neighbour{wire=defines.wire_type.green, target_entity=entity2}
	if not b or not b2 then
		err("Could not connect Cable!")
	end
end



return PLCbuilder