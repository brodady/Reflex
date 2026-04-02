draw_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, false)

var _theme_value = theme ?? __theme;
var _left = bbox_left;
var _top = bbox_top;
var _right = bbox_right;
var _bottom = bbox_bottom;

var _fill_color =
	button_idle_color ??
	_theme_value.button_idle_color ??
	c_dkgray;

switch (__draw_mode)
{
	case "disabled":
		_fill_color = button_disabled_color ?? _theme_value.button_disabled_color ?? _fill_color;
	break;

	case "hover":
	case "checked_hover":
		_fill_color = button_hover_color ?? _theme_value.button_hover_color ?? _fill_color;
	break;

	case "pressed":
	case "hover_pressed":
	case "checked":
		_fill_color = button_pressed_color ?? _theme_value.button_pressed_color ?? _fill_color;
	break;
}

var _border_color =
	button_border_color ??
	_theme_value.button_border_color ??
	c_white;

var _text_color =
	text_color ??
	_theme_value.text_color ??
	c_white;

image_blend = _fill_color ?? c_white;

if (!flat)
{
	draw_set_alpha(1);
	draw_set_color(image_blend);
	draw_roundrect(_left, _top, _right, _bottom, false);
	draw_set_color(_border_color);
	draw_roundrect(_left, _top, _right, _bottom, true);
}

draw_set_color(_text_color);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text((_left + _right) * 0.5, (_top + _bottom) * 0.5, text);
