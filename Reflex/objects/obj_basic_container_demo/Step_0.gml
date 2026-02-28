demo_time += 1;

// Light animation: toggle toolbar alignment with keys 1/2/3
if (keyboard_check_pressed(ord("1"))) {
	row_toolbar.set_alignment(0); // begin
	col_left.set_alignment(0);
}
if (keyboard_check_pressed(ord("2"))) {
	row_toolbar.set_alignment(1); // center
	col_left.set_alignment(1);
}
if (keyboard_check_pressed(ord("3"))) {
	row_toolbar.set_alignment(2); // end
	col_left.set_alignment(2);
}

// Slight separation pulse with Space (stress layout changes)
if (keyboard_check(vk_space))
{
	var _pulse = 6 + 6 * (0.5 + 0.5 * sin(demo_time / 20));
	ui_root.set_separation(_pulse);
	row_content.set_separation(_pulse);
}
else
{
	ui_root.set_separation(12);
	row_content.set_separation(12);
}