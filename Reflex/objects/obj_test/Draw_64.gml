// Draw Sprite Mirror
draw_sprite_ext(my_icon.sprite_index, my_icon.image_index, 
                my_icon.x, my_icon.y, 
                my_icon.scale_x, my_icon.scale_y, 0, c_white, 1);

// Draw Text Mirror
draw_set_font(my_label.font);
draw_text_ext(my_label.x, my_label.y, my_label.text, -1, my_label.w);