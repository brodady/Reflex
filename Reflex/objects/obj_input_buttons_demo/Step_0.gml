if (keyboard_check_pressed(vk_space))
{
	__status_text = "Accept pressed from demo object";
}

if (keyboard_check(vk_up)) {
	__scroll.set_scroll_y(__scroll.get_scroll_y() - 4);
}

if (keyboard_check(vk_down)) {
	__scroll.set_scroll_y(__scroll.get_scroll_y() + 4);
}

