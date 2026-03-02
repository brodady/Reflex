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
demo_last_down = false;

demo_logic_leaf = new ReflexLeafLogic();
demo_logic_leaf.set_width("auto").set_height("auto");
ui_root.add(demo_logic_leaf);

// Inject callbacks into handler instance via ReflexLeafLogic
demo_logic_leaf.set_step(function()
{
	var _mx = device_mouse_x_to_gui(0);
	var _my = device_mouse_y_to_gui(0);

	var _lx = demo_label.get_layout_x();
	var _ly = demo_label.get_layout_y();
	var _lw = demo_label.get_layout_width();
	var _lh = demo_label.get_layout_height();

	var _hover = (_mx >= _lx) && (_mx <= (_lx + _lw)) && (_my >= _ly) && (_my <= (_ly + _lh));

	var _down = mouse_check_button(mb_left);
	var _pressed = _down && (!demo_last_down);

	if (_hover && _pressed)
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

	demo_last_down = _down;
});
demo_logic_leaf.set_draw(function()
{
	// Simple hover outline (runs in handler Draw)
	var _mx = device_mouse_x_to_gui(0);
	var _my = device_mouse_y_to_gui(0);

	var _lx = demo_label.get_layout_x();
	var _ly = demo_label.get_layout_y();
	var _lw = demo_label.get_layout_width();
	var _lh = demo_label.get_layout_height();

	var _hover = (_mx >= _lx) && (_mx <= (_lx + _lw)) && (_my >= _ly) && (_my <= (_ly + _lh));

	draw_set_alpha(0.35);
	draw_set_color(_hover ? c_aqua : c_dkgray);
	draw_rectangle(_lx - 4, _ly - 4, _lx + _lw + 4, _ly + _lh + 4, true);
	draw_set_alpha(1);
});