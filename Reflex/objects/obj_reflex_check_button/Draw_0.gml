var _theme_value = theme ?? __theme;
var _left = bbox_left;
var _top = bbox_top;
var _right = bbox_right;
var _bottom = bbox_bottom;
var _middle_y = (_top + _bottom) * 0.5;
var _track_width = 36;
var _track_height = 18;
var _track_left = _left + 4;
var _track_top = _middle_y - (_track_height * 0.5);
var _track_right = _track_left + _track_width;
var _track_bottom = _track_top + _track_height;
var _thumb_size = 14;

var _track_color = _theme_value.button_idle_color ?? c_dkgray;
var _border_color = _theme_value.button_border_color ?? c_white;
var _thumb_color = _theme_value.button_thumb_color ?? c_white;
var _text_color = _theme_value.text_color ?? c_white;

switch (__draw_mode)
{
	case "disabled":
		_track_color = _theme_value.button_disabled_color ?? _track_color;
	break;

	case "hover":
	case "checked_hover":
		_track_color = _theme_value.button_hover_color ?? _track_color;
	break;

	case "pressed":
	case "hover_pressed":
	case "checked":
		_track_color = _theme_value.button_pressed_color ?? _track_color;
	break;
}

if (button_pressed)
{
	_track_color = _theme_value.button_checked_color ?? _track_color;
}

var _thumb_left = _track_left + 2;
if (button_pressed) {
	_thumb_left = _track_right - _thumb_size - 2;
}
var _thumb_top = _middle_y - (_thumb_size * 0.5);
var _thumb_right = _thumb_left + _thumb_size;
var _thumb_bottom = _thumb_top + _thumb_size;

draw_set_alpha(1);
draw_set_color(_track_color);
draw_roundrect(_track_left, _track_top, _track_right, _track_bottom, false);
draw_set_color(_border_color);
draw_roundrect(_track_left, _track_top, _track_right, _track_bottom, true);
draw_set_color(_thumb_color);
draw_roundrect(_thumb_left, _thumb_top, _thumb_right, _thumb_bottom, false);

draw_set_color(_text_color);
draw_set_halign(fa_left);
draw_set_valign(fa_middle);
draw_text(_track_right + 8, _middle_y, text);
