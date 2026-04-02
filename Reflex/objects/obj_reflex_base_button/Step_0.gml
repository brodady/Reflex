__hovered = false;
__held = false;
__focused = false;
__draw_mode = "normal";

if (disabled)
{
	__draw_mode = "disabled";
	exit;
}

input_register(id);
__reflex_input.keep_pressed_outside = keep_pressed_outside;

__hovered = input_hovered(id);
__held = input_active(id);
__focused = input_focused(id);

if (__held)
{
	if (__hovered) {
		__draw_mode = "hover_pressed";
	} else {
		__draw_mode = "pressed";
	}
}
else if (__hovered)
{
	__draw_mode = "hover";
}

if (toggle_mode && button_pressed)
{
	if (__draw_mode == "normal") {
		__draw_mode = "checked";
	} else if (__draw_mode == "hover") {
		__draw_mode = "checked_hover";
	}
}

if (action_mode == 1 && input_pressed(id))
{
	if (toggle_mode)
	{
		button_pressed = !button_pressed;
		if (on_toggled != undefined) {
			on_toggled(id, button_pressed);
		}
	}

	if (on_pressed != undefined) {
		on_pressed(id);
	}

	input_consume_pointer();
}

if (action_mode == 0 && input_released(id))
{
	if (keep_pressed_outside || input_hovered(id))
	{
		if (toggle_mode)
		{
			button_pressed = !button_pressed;
			if (on_toggled != undefined) {
				on_toggled(id, button_pressed);
			}
		}

		if (on_pressed != undefined) {
			on_pressed(id);
		}

		input_consume_pointer();
	}
}

if (__focused && input_action_pressed("accept"))
{
	if (toggle_mode)
	{
		button_pressed = !button_pressed;
		if (on_toggled != undefined) {
			on_toggled(id, button_pressed);
		}
	}

	if (on_pressed != undefined) {
		on_pressed(id);
	}

	input_action_consume("accept");
}
