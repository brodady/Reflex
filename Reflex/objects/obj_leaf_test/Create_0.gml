// obj_test: Create Event
ui_root = new Reflex(); 
ui_root.set_width("100%").set_height("100%").set_padding(flexpanel_edge.all_edges, 20);
ui_root.set_flex_direction(flexpanel_flex_direction.row);
ui_root.set_flex_wrap(flexpanel_wrap.wrap);
ui_root.add_to();

my_label = new ReflexText("Testing Reflow", fnt_lbl); 
my_label.set_width("auto").set_height("auto")

my_icon = new ReflexSprite(spr_test, 0);
my_icon.set_width("auto").set_height("auto")

ui_root.add(my_label);
ui_root.add(my_icon);

