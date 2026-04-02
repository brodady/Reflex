draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

draw_text(16, 160, "Status: " + __status_text);
draw_text(16, 176, "Outside Toggle: " + string(__status_toggle_a));
draw_text(16, 192, "Inside Toggle: " + string(__status_toggle_b));
draw_text(16, 208, "Expected:");
draw_text(32, 224, "- Outside buttons always clickable");
draw_text(32, 240, "- Inside buttons only clickable while visible inside the scroll viewport");
draw_text(32, 256, "- Clipped portions should not receive hover/click");
draw_text(32, 272, "- Up/Down keys can be used to move the scroll region once wired");
draw_text(32, 290, json_stringify(__reflex_input_manager_get().registrations, true));

__ui_root.draw_debug(0, -1, keyboard_check(ord("P")), keyboard_check(ord("M")), keyboard_check(ord("N")));

