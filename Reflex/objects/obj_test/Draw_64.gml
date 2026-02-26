// --- REGULAR RENDERING ---
// Draw Sprite
if (variable_instance_exists(self, "my_icon")) {
    draw_sprite(my_icon.sprite_index, my_icon.image_index, my_icon.x, my_icon.y);
}

// Draw Text
draw_set_font(my_label.font);
draw_set_color(c_white);
draw_text(my_label.x, my_label.y, my_label.text);


// --- DEBUG OVERLAY ---
if (keyboard_check(vk_control)) {
    ui_root.draw_debug();
}