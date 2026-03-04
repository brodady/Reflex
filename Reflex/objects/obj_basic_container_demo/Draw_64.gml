draw_clear_alpha(c_white, 1);

ui_root.draw_debug(0, -1, keyboard_check(ord("P")), keyboard_check(ord("M")), keyboard_check(ord("N")));

draw_set_color(c_black);
draw_text(16, 16, "ReflexFlowContainer integrated demo");
draw_text(16, 36, "Keys: 1/2/3 alignment, R reverse_fill, V vertical, hold Space to pulse gaps.");
draw_text(16, 56, "reverse_fill: " + string(demo_reverse_fill) + "  vertical: " + string(demo_vertical_flow));