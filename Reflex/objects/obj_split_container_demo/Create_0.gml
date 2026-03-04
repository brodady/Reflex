// Main vertical split: (top controls) / (main content)
main_split = new ReflexVSplitContainer();
main_split.add_to("ReflexLayer");
main_split.set_width("80%");
main_split.set_height("80%");
main_split.set_split_offset(60);
main_split.set_dragger_visibility(ReflexSplitContainerDraggerVisibility.DRAGGER_VISIBLE);

var _toolbar = main_split.get_pane_a();
_toolbar.set_name("toolbar");


// Right side split: (center) | (properties)
right_split = new ReflexHSplitContainer();
right_split.add_to(main_split.get_pane_b());
right_split.set_split_ratio(0.7);
right_split.set_min_pane_a(200);
right_split.set_min_pane_b(150);
right_split.set_divider_size(6);

// Horizontal split: (left panel) | (center + right)
left_split = new ReflexHSplitContainer();
left_split.add_to(right_split.get_pane_a());
left_split.set_split_offset(250);
left_split.set_min_pane_a(150);
left_split.set_min_pane_b(300);
left_split.set_divider_size(6);

var _left_panel = left_split.get_pane_a();
_left_panel.set_name("explorer");

var _center = left_split.get_pane_b();
_center.set_name("editor");

//*
// Center vertical split: (editor) / (console)
center_split = new ReflexVSplitContainer();
center_split.add_to(_center);
center_split.set_split_ratio(0.75);
center_split.set_min_pane_b(80);
center_split.set_divider_size(6);
center_split.set_anchor_mode(ReflexSplitContainerAnchorMode.ANCHOR_B)

var _editor = center_split.get_pane_a();
_editor.set_name("editor_main");

var _console = center_split.get_pane_b();
_console.set_name("console");

var _properties = right_split.get_pane_b();
_properties.set_name("properties");

// Store references for easy access
layout = {
	toolbar: _toolbar,
	explorer: _left_panel,
	editor: _editor,
	console: _console,
	properties: _properties
};

// Set up event listeners for debugging
left_split.on_drag_started(function() {
	show_debug_message("[H-Split] Drag started");
});

left_split.on_dragged(function(_offset) {
	show_debug_message("[H-Split] Offset: " + string(_offset));
});

left_split.on_drag_ended(function() {
	show_debug_message("[H-Split] Drag ended at: " + string(left_split.get_split_offset()));
});

// Similar for other splits
right_split.on_dragged(function(_offset) {
	show_debug_message("[Right-Split] Ratio: " + string(right_split.get_split_ratio()));
});

center_split.on_dragged(function(_offset) {
	show_debug_message("[Center-Split] Offset: " + string(_offset));
});

show_debug_message("=== IDE Layout Created ===");
show_debug_message("Controls:");
show_debug_message("  [Space] - Toggle explorer panel");
show_debug_message("  [C] - Toggle console");
show_debug_message("  [P] - Toggle properties panel");
show_debug_message("  [D] - Toggle debug visualization");
show_debug_message("  [R] - Reset to default sizes");


show_debug = false;