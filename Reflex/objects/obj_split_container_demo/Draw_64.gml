//*
// Draw labels in each panel to identify them
draw_set_font(-1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

// Toolbar
var _toolbar_layout = layout.toolbar.get_layout_position();
draw_set_color(c_blue);
draw_set_alpha(0.3);
draw_rectangle(
	_toolbar_layout.left, _toolbar_layout.top,
	_toolbar_layout.left + _toolbar_layout.width,
	_toolbar_layout.top + _toolbar_layout.height,
	false
);
draw_set_alpha(1.0);
draw_set_color(c_white);
draw_text(_toolbar_layout.left + 10, _toolbar_layout.top + 10, "TOOLBAR");

// Explorer
var _explorer_layout = layout.explorer.get_layout_position();
draw_set_color(c_green);
draw_set_alpha(0.2);
draw_rectangle(
	_explorer_layout.left, _explorer_layout.top,
	_explorer_layout.left + _explorer_layout.width,
	_explorer_layout.top + _explorer_layout.height,
	false
);
draw_set_alpha(1.0);
draw_set_color(c_white);
draw_text(_explorer_layout.left + 10, _explorer_layout.top + 10, "EXPLORER\n[Space] to toggle");

// Editor
var _editor_layout = layout.editor.get_layout_position();
draw_set_color(c_yellow);
draw_set_alpha(0.2);
draw_rectangle(
	_editor_layout.left, _editor_layout.top,
	_editor_layout.left + _editor_layout.width,
	_editor_layout.top + _editor_layout.height,
	false
);
draw_set_alpha(1.0);
draw_set_color(c_white);
draw_text(_editor_layout.left + 10, _editor_layout.top + 10, "EDITOR");

// Console
var _console_layout = layout.console.get_layout_position();
draw_set_color(c_red);
draw_set_alpha(0.2);
draw_rectangle(
	_console_layout.left, _console_layout.top,
	_console_layout.left + _console_layout.width,
	_console_layout.top + _console_layout.height,
	false
);
draw_set_alpha(1.0);
draw_set_color(c_white);
draw_text(_console_layout.left + 10, _console_layout.top + 10, "CONSOLE\n[C] to toggle");

// Properties
var _properties_layout = layout.properties.get_layout_position();
draw_set_color(c_purple);
draw_set_alpha(0.2);
draw_rectangle(
	_properties_layout.left, _properties_layout.top,
	_properties_layout.left + _properties_layout.width,
	_properties_layout.top + _properties_layout.height,
	false
);
draw_set_alpha(1.0);
draw_set_color(c_white);
draw_text(_properties_layout.left + 10, _properties_layout.top + 10, "PROPERTIES\n[P] to toggle");

// Draw instructions
draw_set_color(c_white);
draw_text(10, 20, 
	"Controls:\n" +
	"  [Space] - Toggle explorer\n" +
	"  [C] - Toggle console\n" +
	"  [P] - Toggle properties\n" +
	"  [D] - Toggle debug view\n" +
	"  [R] - Reset layout"
);

// Draw split info
draw_text(10, 220,
	"Split Info:\n" +
	"  H-Split: " + string(floor(left_split.get_split_offset())) + "px\n" +
	"  Right: " + string(floor(right_split.get_split_ratio() * 100)) + "%\n" +
	"  Center: " + string(floor(center_split.get_split_ratio() * 100)) + "%"
);

// Optional: Debug visualization
if (show_debug) {
	main_split.draw_debug(0, -1, true, true, true);
}
