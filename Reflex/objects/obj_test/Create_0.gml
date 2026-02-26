// obj_test: Create Event
ui_root = new Reflex("root"); 
ui_root.set_width("100%").set_height("100%").set_padding(flexpanel_edge.all_edges, 20);
ui_root.set_align_items(flexpanel_align.flex_start); 
ui_root.set_justify_content(flexpanel_justify.start);
ui_root.set_flex_direction(flexpanel_flex_direction.row);

// Text Leaf
my_label = new ReflexText("Testing Reflow", fnt_lbl); 
my_label.set_width("auto").set_height("auto");

// Sprite Leaf
my_icon = new ReflexSprite(spr_test, 0);
my_icon.set_width("auto").set_height("auto");

ui_root.add(my_label);
ui_root.add(my_icon);


ui_root.attempt_reflow();