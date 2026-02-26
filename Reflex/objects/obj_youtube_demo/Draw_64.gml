layout_root.request_reflow();
layout_root.attempt_reflow();

layout_root.draw_debug(0, -1, keyboard_check(ord("P")), keyboard_check(ord("M")), keyboard_check(ord("N")));