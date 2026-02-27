draw_clear_alpha(c_white, 1);

// Debug draw the whole tree
grid_root.draw_debug(0, -1, keyboard_check(ord("P")), keyboard_check(ord("M")), keyboard_check(ord("N")));

draw_set_color(c_white);
draw_set_alpha(0.75)
draw_rectangle(16, 16, 660, 116, false)

draw_set_color(c_black);
draw_set_alpha(1)
draw_text(16, 16, "2x2 ReflexGrid demo");
draw_text(16, 36, "Top-left: 4x4 inventory");
draw_text(16, 56, "Top-right: auto grid (press A add/remove)");
draw_text(16, 76, "Bottom-left: span layout (header/left/body/right/footer)");
draw_text(16, 96, "Bottom-right: mixed fixed + auto packing (press C clear/restore a lock)");