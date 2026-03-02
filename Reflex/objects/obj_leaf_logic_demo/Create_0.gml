ui_root = new Reflex();
ui_root.set_width("100%").set_height("100%");
ui_root.set_padding(flexpanel_edge.all_edges, 32);
ui_root.set_flex_direction(flexpanel_flex_direction.column);
ui_root.set_flex_wrap(flexpanel_wrap.no_wrap);
ui_root.add_to("ReflexLayer");

demo_label = new ReflexLeafText("Click Count: 0", fnt_lbl);
demo_label.set_width("auto").set_height("auto");
ui_root.add(demo_label);

demo_count = 0;

demo_logic_leaf = new ReflexLeafLogic();
demo_logic_leaf.set_width("auto").set_height("auto");
ui_root.add(demo_logic_leaf);

// Inject callbacks into handler instance via ReflexLeafLogic
demo_logic_leaf.set_step(function()
{
	var _mx = device_mouse_x_to_gui(0);
	var _my = device_mouse_y_to_gui(0);

	var _x = demo_label.get_layout_left();
	var _y = demo_label.get_layout_top();
	var _w = demo_label.get_layout_width();
	var _h = demo_label.get_layout_height();
	
	if (point_in_rectangle(_mx, _my, _x, _y,  _x+_w, _y+_h))
	&& (mouse_check_button_pressed(mb_left))
	{
		demo_count += 1;
		demo_label.set_text_text("Click Count: " + string(demo_count));

		// Visual confirmation
		if ((demo_count mod 2) == 0)
		{
			demo_label.set_text_color(c_orange);
		}
		else
		{
			demo_label.set_text_color(c_lime);
		}
	}
});
demo_logic_leaf.set_draw(function()
{
	// Simple hover outline (runs in handler Draw)
	var _mx = device_mouse_x_to_gui(0);
	var _my = device_mouse_y_to_gui(0);

	var _x = demo_label.get_layout_left();
	var _y = demo_label.get_layout_top();
	var _w = demo_label.get_layout_width();
	var _h = demo_label.get_layout_height();
	
	var _hover = point_in_rectangle(_mx, _my, _x, _y,  _x+_w, _y+_h);

	draw_set_alpha(0.35);
	draw_set_color(_hover ? c_aqua : c_dkgray);
	draw_rectangle(_x - 4, _y - 4, _x+_w + 4, _y+_h + 4, true);
	draw_set_alpha(1);
});