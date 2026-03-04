draw_clear_alpha(c_white, 1);

// Debug render
ui_root.draw_debug(0, -1, keyboard_check(ord("P")), keyboard_check(ord("M")), keyboard_check(ord("N")));

draw_set_color(c_black);
draw_text(16, 16, "ReflexContainer demo");
draw_text(16, 36, "Keys: 1/2/3 change toolbar alignment. Hold Space to pulse separation.");