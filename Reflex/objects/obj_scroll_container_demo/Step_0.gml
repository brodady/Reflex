var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();

if ((_gui_w != gui_w_last) || (_gui_h != gui_h_last))
{
	flexpanel_calculate_layout(ui_root.node_handle, _gui_w, _gui_h, flexpanel_direction.LTR);
	gui_w_last = _gui_w;
	gui_h_last = _gui_h;
}

// Toggle content sizing so you can see the exact failure mode when it's missing
if (keyboard_check_pressed(vk_space))
{
	size_set = !size_set;

	if (size_set)
	{
		scroll.set_content_size(content_w, content_h);
	}
	else
	{
		scroll.set_content_size(0, 0);
		scroll.set_scroll(0, 0);
	}
}

// Nudge scroll values to see clamping behavior when max == 0
if (keyboard_check(vk_left))  { scroll.set_scroll_x(scroll.get_scroll_x() - 6); }
if (keyboard_check(vk_right)) { scroll.set_scroll_x(scroll.get_scroll_x() + 6); }
if (keyboard_check(vk_up))    { scroll.set_scroll_y(scroll.get_scroll_y() - 6); }
if (keyboard_check(vk_down))  { scroll.set_scroll_y(scroll.get_scroll_y() + 6); }