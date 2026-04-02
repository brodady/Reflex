var _theme_value = theme ?? __theme;
var _text_color = text_color ?? _theme_value.text_color ?? c_white;

switch (__draw_mode)
{
	case "disabled":
		_text_color = button_disabled_color ?? _theme_value.button_disabled_color ?? _text_color;
	break;

	case "hover":
	case "checked_hover":
		_text_color = button_hover_color ?? _theme_value.button_hover_color ?? _text_color;
	break;

	case "pressed":
	case "hover_pressed":
	case "checked":
		_text_color = button_pressed_color ?? _theme_value.button_pressed_color ?? _text_color;
	break;
}

var _left = bbox_left;
var _top = bbox_top;
var _right = bbox_right;
var _bottom = bbox_bottom;
var _middle_y = (_top + _bottom) * 0.5;

draw_set_alpha(1);
draw_set_color(_text_color);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text((_left + _right) * 0.5, _middle_y, text);

if (__hovered)
{
	var _underline_y = _bottom - 2;
	draw_line(_left, _underline_y, _right, _underline_y);
}
