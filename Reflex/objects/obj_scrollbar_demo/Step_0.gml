

// Apply scroll to content offsets (polling, no callbacks needed).
var _scroll_x = hbar.get_value();
var _scroll_y = vbar.get_value();

if (_scroll_x != scroll_x_last)
|| (_scroll_y != scroll_y_last)
{
	content.set_sprite_offsets(-_scroll_x, -_scroll_y);

	scroll_x_last = _scroll_x;
	scroll_y_last = _scroll_y;
}