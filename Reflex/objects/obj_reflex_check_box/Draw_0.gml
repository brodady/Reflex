var _theme_value = theme ?? __theme;
var _left = bbox_left;
var _top = bbox_top;
var _right = bbox_right;
var _bottom = bbox_bottom;
var _height = _bottom - _top;
var _box_size = max(8, _height - 8);
var _box_left = _left + 4;
var _box_top = _top + 4;
var _box_right = _box_left + _box_size;
var _box_bottom = _box_top + _box_size;

var _fill_color = _theme_value.button_idle_color ?? c_dkgray;
var _border_color = _theme_value.button_border_color ?? c_white;
var _text_color = _theme_value.text_color ?? c_white;
var _check_color = _theme_value.button_checked_color ?? c_white;

switch (__draw_mode)
{
	case "disabled":
		_fill_color = _theme_value.button_disabled_color ?? _fill_color;
	break;

	case "hover":
	case "checked_hover":
		_fill_color = _theme_value.button_hover_color ?? _fill_color;
	break;

	case "pressed":
	case "hover_pressed":
	case "checked":
		_fill_color = _theme_value.button_pressed_color ?? _fill_color;
	break;
}

draw_set_alpha(1);
draw_set_color(_fill_color);
draw_roundrect(_left, _top, _right, _bottom, false);
draw_set_color(_border_color);
draw_roundrect(_box_left, _box_top, _box_right, _box_bottom, true);

if (button_pressed)
{
	draw_set_color(_check_color);
	draw_roundrect(_box_left + 3, _box_top + 3, _box_right - 3, _box_bottom - 3, false);
}

draw_set_color(_text_color);
draw_set_halign(fa_left);
draw_set_valign(fa_middle);
draw_text(_box_right + 8, (_top + _bottom) * 0.5, text);
