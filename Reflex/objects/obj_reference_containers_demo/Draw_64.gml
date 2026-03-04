draw_clear_alpha(c_white, 1);

// Debug render
ui_root.draw_debug(0, -1, keyboard_check(ord("P")), keyboard_check(ord("M")), keyboard_check(ord("N")));

// Minimal on-screen help
draw_set_color(c_black);
draw_text(16, 16, "Demo Controls:");
draw_text(16, 36, "1: Center top-left toggle");
draw_text(16, 56, "2: PaddingContainer inset cycle");
draw_text(16, 76, "3: MarginContainer outer cycle");
draw_text(16, 96, "4: Aspect stretch_mode cycle (0..3)");
draw_text(16, 116, "5/6: Aspect align H/V cycle (0..2)");