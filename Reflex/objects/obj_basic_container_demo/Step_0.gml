demo_time += 1;

// Toolbar + left column alignment (1/2/3)
if (keyboard_check_pressed(ord("1"))) {
	row_toolbar.set_alignment(0);
	col_left.set_alignment(0);
	flow_main.set_alignment(0);
}
if (keyboard_check_pressed(ord("2"))) {
	row_toolbar.set_alignment(1);
	col_left.set_alignment(1);
	flow_main.set_alignment(1);
}
if (keyboard_check_pressed(ord("3"))) {
	row_toolbar.set_alignment(2);
	col_left.set_alignment(2);
	flow_main.set_alignment(2);
}

// Reverse fill toggle (R)
if (keyboard_check_pressed(ord("R")))
{
	demo_reverse_fill = !demo_reverse_fill;
	flow_main.set_reverse_fill(demo_reverse_fill);
}

// Vertical flow toggle (V)
if (keyboard_check_pressed(ord("V")))
{
	demo_vertical_flow = !demo_vertical_flow;
	flow_main.set_vertical(demo_vertical_flow);
}

// Separation pulse with Space
if (keyboard_check(vk_space))
{
	var _pulse = 6 + 6 * (0.5 + 0.5 * sin(demo_time / 20));
	ui_root.set_separation(_pulse);
	row_content.set_separation(_pulse);

	row_toolbar.set_separation(_pulse);
	col_left.set_separation(_pulse);

	flow_main.set_separation(_pulse);
}
else
{
	ui_root.set_separation(12);
	row_content.set_separation(12);

	row_toolbar.set_separation(8);
	col_left.set_separation(8);

	flow_main.set_separation(8);
}