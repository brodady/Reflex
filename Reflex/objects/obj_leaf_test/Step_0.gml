// Test 1: Change text length
if (keyboard_check_pressed(vk_space)) {
    my_label.set_text_text("This is a much longer string of text to test if the layout reflows!");
}

// Test 2: Reset text
if (keyboard_check_pressed(vk_escape)) {
    my_label.set_text_text("Short again.");
}
