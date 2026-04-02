__ui_root = undefined;
__outside_row = undefined;
__scroll = undefined;
__scroll_content = undefined;

__status_text = "No input yet";
__status_toggle_a = false;
__status_toggle_b = false;

__theme = {
	button_idle_color: make_color_rgb(36, 36, 36),
	button_hover_color: make_color_rgb(52, 52, 52),
	button_pressed_color: make_color_rgb(24, 24, 24),
	button_disabled_color: make_color_rgb(18, 18, 18),
	button_border_color: make_color_rgb(110, 110, 110),
	
	text_color: c_white,
	button_checked_color: c_white,
	button_thumb_color: c_white,
};

__ui_root = new ReflexUI()
	.set_name("DemoRoot")
	.add_to("ReflexLayer");

__outside_row = new ReflexUI()
	.set_name("OutsideRow")
	.set_flex_direction(flexpanel_flex_direction.row)
	.set_gap(flexpanel_gutter.column, 8)
	.set_padding_left(16)
	.set_padding_top(16)
	.set_align_items(flexpanel_align.flex_start)
	.add_to(__ui_root);

var _button_outside_a = new ReflexButton("Outside A")
	.set_size(120, 28)
	.set_theme(__theme)
	.set_on_pressed(function(_instance_id) {
		__status_text = "Pressed Outside A";
	})
	.add_to(__outside_row);

var _button_outside_b = new ReflexButton("Outside B")
	.set_size(120, 28)
	.set_theme(__theme)
	.set_on_pressed(function(_instance_id) {
		__status_text = "Pressed Outside B";
	})
	.add_to(__outside_row);

var _button_outside_check = new ReflexCheckBox("Outside Toggle")
	.set_size(160, 28)
	.set_theme(__theme)
	.set_on_toggled(function(_instance_id, _pressed_value) {
		__status_toggle_a = _pressed_value;
		__status_text = "Outside Toggle = " + string(_pressed_value);
	})
	.add_to(__outside_row);

/// Replace ReflexScrollContainer with your real scroll container wrapper.
/// The expected behavior here is:
/// - fixed viewport size
/// - content clipped to viewport
/// - child content node larger than viewport
/// - scroll offset support, or at minimum a pre-offset content node
__scroll = new ReflexScrollContainer()
	.set_name("DemoScroll")
	.set_width(240)
	.set_height(100)
	.add_to(__ui_root)

/// This content node is intentionally taller than the viewport so some buttons
/// begin clipped or become clipped when scrolled.
/// If your scroll container already owns a content node internally, remove this
/// and add the buttons to that internal content node instead.
__scroll_content = new ReflexUI()
	.set_name("DemoScrollContent")
	.set_flex_direction(flexpanel_flex_direction.column)
	.set_gap(flexpanel_gutter.row, 8)
	.set_padding_left(8)
	.set_padding_top(8)
	.set_width(200)
	.set_height(220)
	.add_to(__scroll)

var _button_inside_a = new ReflexButton("Inside A")
	.set_size(180, 28)
	.set_theme(__theme)
	.set_on_pressed(function(_instance_id) {
		__status_text = "Pressed Inside A";
	})
	.add_to(__scroll_content);

var _button_inside_b = new ReflexButton("Inside B")
	.set_size(180, 28)
	.set_theme(__theme)
	.set_on_pressed(function(_instance_id) {
		__status_text = "Pressed Inside B";
	})
	.add_to(__scroll_content);

var _button_inside_check = new ReflexCheckButton("Inside Toggle")
	.set_size(180, 28)
	.set_theme(__theme)
	.set_on_toggled(function(_instance_id, _pressed_value) {
		__status_toggle_b = _pressed_value;
		__status_text = "Inside Toggle = " + string(_pressed_value);
	})
	.add_to(__scroll_content);

var _button_inside_c = new ReflexButton("Inside C")
	.set_size(180, 28)
	.set_theme(__theme)
	.set_on_pressed(function(_instance_id) {
		__status_text = "Pressed Inside C";
	})
	.add_to(__scroll_content);

var _button_inside_d = new ReflexButton("Inside D")
	.set_size(180, 28)
	.set_theme(__theme)
	.set_on_pressed(function(_instance_id) {
		__status_text = "Pressed Inside D";
	})
	.add_to(__scroll_content);

var _button_inside_e = new ReflexButton("Inside E")
	.set_size(180, 28)
	.set_theme(__theme)
	.set_on_pressed(function(_instance_id) {
		__status_text = "Pressed Inside E";
	})
	.add_to(__scroll_content);


