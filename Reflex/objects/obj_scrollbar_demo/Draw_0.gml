/*
draw_set_alpha(1);
draw_set_color(c_lime);

// Root debug rect
var _rx = _ui_root.get_layout_left();
var _ry = _ui_root.get_layout_top();
var _rw = _ui_root.get_layout_width();
var _rh = _ui_root.get_layout_height();
draw_rectangle(_rx, _ry, _rx + _rw, _ry + _rh, true);

// Viewport debug rect
var _vx = _ui_viewport.get_layout_left();
var _vy = _ui_viewport.get_layout_top();
var _vw = _ui_viewport.get_layout_width();
var _vh = _ui_viewport.get_layout_height();
draw_rectangle(_vx, _vy, _vx + _vw, _vy + _vh, true);

// Values
draw_set_color(c_white);
draw_text(_vx + 160, _vy + 6, "H: " + string(_hbar.get_value()) + " / " + string(_hbar.get_max()));
draw_text(_vx + 160, _vy + 22, "V: " + string(_vbar.get_value()) + " / " + string(_vbar.get_max()));
//*/
ui_root.draw_debug(0, -1, keyboard_check(ord("P")), keyboard_check(ord("M")), keyboard_check(ord("N")));