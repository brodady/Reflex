draw_set_alpha(1);
draw_set_color(c_white);

var _view = scroll.get_viewport();

var _vx = _view.get_layout_left();
var _vy = _view.get_layout_top();
var _vw = _view.get_layout_width();
var _vh = _view.get_layout_height();

draw_text(12, 12, "Space: toggle content size (currently " + string(size_set) + ")");
draw_text(12, 28, "Arrows: nudge scroll values");

draw_text(12, 52, "Scroll X: " + string(scroll.get_scroll_x()));
draw_text(12, 68, "Scroll Y: " + string(scroll.get_scroll_y()));

draw_text(12, 92, "Viewport w/h: " + string(_vw) + " / " + string(_vh));

// Outline viewport so you can see clipping bounds
draw_set_color(c_lime);
draw_rectangle(_vx, _vy, _vx + _vw, _vy + _vh, true);

ui_root.draw_debug(0, -1, keyboard_check(ord("P")), keyboard_check(ord("M")), keyboard_check(ord("N")));