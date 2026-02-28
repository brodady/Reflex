draw_set_color(c_white);
draw_text(16, 16, "Leaf demo (UI layer renders leaf elements)");
draw_text(16, 36, "A toggle attach, 1 sprite, 2 text, 3 instance, 4 remove last, 5 clear");

leaf_host.draw_debug(0, 1, true, true, true);

// --- DEBUG OVERLAY ---
//ui_root.draw_debug(0, -1, keyboard_check(ord("P")), keyboard_check(ord("M")), keyboard_check(ord("N")));