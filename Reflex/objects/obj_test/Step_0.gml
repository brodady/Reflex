// Test 1: Change text length
if (keyboard_check_pressed(vk_space)) {
    my_label.set_text("This is a much longer string of text to test if the layout reflows!");
}

// Test 2: Reset text
if (keyboard_check_pressed(vk_escape)) {
    my_label.set_text("Short again.");
}

// Global attempt to reflow. This checks if the root is "dirty" 
// and propagates absolute x/y to all mirrors.
ui_root.attempt_reflow(0, 0, window_get_width(), window_get_height());
