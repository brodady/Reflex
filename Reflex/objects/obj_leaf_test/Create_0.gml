// obj_test: Create Event
ui_root = new Reflex(); 
ui_root.set_width("100%").set_height("100%").set_padding(flexpanel_edge.all_edges, 20);
ui_root.set_flex_direction(flexpanel_flex_direction.row);
ui_root.set_flex_wrap(flexpanel_wrap.wrap);

my_label = new ReflexText("Testing Reflow", fnt_lbl); 
my_label.set_width("auto").set_height("auto")

my_icon = new ReflexSprite(spr_test, 0);
my_icon.set_width("auto").set_height("auto")

ui_root.add(my_label);
ui_root.add(my_icon);

// 2. NEW: Attach the Reflex tree to the Room's UI Layer!
var _layer_node = layer_get_flexpanel_node("UI_ROOT");
flexpanel_node_insert_child(_layer_node, ui_root.node_handle, 0);

// Calculate layout on the LAYER node, not just your wrapper
ui_root.attempt_reflow();
flexpanel_calculate_layout(_layer_node, window_get_width(), window_get_height(), flexpanel_direction.LTR);