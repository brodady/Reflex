// --- REGULAR RENDERING ---
// Draw Sprite
my_icon.draw_this()


// Draw Text
my_label.draw_this()


// --- DEBUG OVERLAY ---
if (keyboard_check(vk_control)) {
    ui_root.draw_debug();
}