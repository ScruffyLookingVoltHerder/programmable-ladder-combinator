local Event = require('__stdlib2__/stdlib/event/event')
local PLCEditor={}

function PLCEditor.open_editor(player, entity)
    local editor={}
    -- create window
    local gui = player.gui.screen.add{type = "frame", name = "my-mod-gui", direction = "vertical"}
    gui.style.natural_height=600
    gui.style.maximal_height=600
    gui.auto_center = true
    editor.window=gui

    --main window flow
    add_titlebar(gui, "PLC Editor", "my-mod-x-button")
    local main_flow = gui.add{type = "flow",direction = "horizontal"}
    local main_TP=main_flow.add{type="tabbed-pane"}
    main_TP.style.vertically_stretchable=true

    --tabs
    local programtab = main_TP.add{type="tab", caption="Program"}
    local tagtab = main_TP.add{type="tab", caption="Tags"}
    local UDTtab = main_TP.add{type="tab", caption="UDTs"}

    --flows inside tabs
    local programflow=main_TP.add{type = "flow",direction = "vertical"}
    local tagflow=main_TP.add{type = "flow",direction = "vertical"}
    local udtflow=main_TP.add{type = "flow",direction = "horizontal"}

    --add tabs
    main_TP.add_tab(programtab, programflow)
    main_TP.add_tab(tagtab, tagflow)
    main_TP.add_tab(UDTtab, udtflow)


  --UDT datatypes pane
  local udt_dt_frame=udtflow.add{type = "frame",direction = "vertical"}
  udt_dt_frame.add{ type = "label",  style = "frame_title",  caption ="Datatypes",  ignored_by_interaction = true,}
  local udt_buttons=udt_dt_frame.add{type = "flow",direction = "horizontal"}
  local new_udt_button=udt_buttons.add{type="button", name="new_UDT", caption="New UDT"}
  local delete_udt_button=udt_buttons.add{type="button", name="delete_UDT", caption="Delete UDT"}
  local udt_pane=udt_dt_frame.add{type = "scroll-pane",direction = "vertical"}
  udt_pane.style.horizontally_stretchable=true
  udt_pane.style.vertically_stretchable=true

  editor.new_udt_button=new_udt_button
  editor.delete_udt_button=delete_udt_button
  editor.udt_pane=udt_pane

  --UDT members pane 
  local udt_member_frame=udtflow.add{type = "frame",direction = "vertical"}
  udt_member_frame.add{ type = "label",  style = "frame_title",  caption ="Members",  ignored_by_interaction = true,}
  local member_buttons=udt_member_frame.add{type = "flow",direction = "horizontal"}
  local new_member_button=member_buttons.add{type="button", name="new_Member", caption="New UDT Member"}
  local delete_member_button=member_buttons.add{type="button", name="delete_Member", caption="Delete UDT Member"}
  local member_pane=udt_member_frame.add{type = "scroll-pane",direction = "vertical"}
  member_pane.style.horizontally_stretchable=true
  member_pane.style.vertically_stretchable=true

  editor.new_member_button=new_member_button
  editor.delete_member_button=delete_member_button
  editor.member_pane=member_pane

  -- Tags pane
  local tags_buttons=tagflow.add{type = "flow",direction = "horizontal"}
  local new_tag_button=tags_buttons.add{type="button", name="new_tag", caption="New Tag"}
  local delete_tag_button=tags_buttons.add{type="button", name="delete_tag", caption="Delete Tag"}
  editor.new_tag_button=new_tag_button
  editor.delete_tag_button=delete_tag_button

  local tag_headings=tagflow.add{type = "flow",direction = "horizontal"}
  local header1=tag_headings.add{ type = "label",  style = "frame_title",  caption ="Tagname",  ignored_by_interaction = true,}
  local header2=tag_headings.add{ type = "label",  style = "frame_title",  caption ="Value",  ignored_by_interaction = true,}
  local header3=tag_headings.add{ type = "label",  style = "frame_title",  caption ="Type",  ignored_by_interaction = true,}
  local header4=tag_headings.add{ type = "label",  style = "frame_title",  caption ="Comment",  ignored_by_interaction = true,}

  local tag_pane=tagflow.add{type = "scroll-pane",direction = "vertical"}
  local tagtable=tag_pane.add{name="tag_table", type="table", column_count=4,draw_vertical_lines=true,draw_horizontal_lines=true,draw_horizontal_line_after_headers=true}
  tag_pane.style.horizontally_stretchable=true
  tagtable.style.horizontally_stretchable=true
  editor.tagtable=tagtable

  

  

end

Event.register(defines.events.on_gui_click, function(event)

    local test=0

end)


function add_titlebar(gui, caption, close_button_name)
    local titlebar = gui.add{type = "flow"}
    titlebar.drag_target = gui
    titlebar.add{
      type = "label",
      style = "frame_title",
      caption = caption,
      ignored_by_interaction = true,
    }
    local filler = titlebar.add{
      type = "empty-widget",
      style = "draggable_space",
      ignored_by_interaction = true,
    }
    filler.style.height = 24
    filler.style.horizontally_stretchable = true
    titlebar.add{
      type = "sprite-button",
      name = close_button_name,
      style = "frame_action_button",
      sprite = "utility/close",
      hovered_sprite = "utility/close_black",
      clicked_sprite = "utility/close_black",
      tooltip = {"gui.close-instruction"},
    }
  end

return PLCEditor