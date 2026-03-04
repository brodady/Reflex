show_debug_overlay(true);

// Root container (vertical)
ui_root = new ReflexVBoxContainer();
ui_root.set_name("UIRoot");
ui_root.set_separation(12);
ui_root.set_width("80%");
ui_root.set_height("80%");
ui_root.set_padding(flexpanel_edge.all_edges, 16, flexpanel_unit.point);

// A top "toolbar" row (unchanged, no wrap)
row_toolbar = new ReflexHBoxContainer();
row_toolbar.set_name("Toolbar");
row_toolbar.set_separation(8);
row_toolbar.set_alignment(0); // begin
row_toolbar.set_height(56, flexpanel_unit.point);

// Three "buttons"
btn_a = new ReflexUI(); btn_a.set_name("BtnA"); btn_a.set_width(90, flexpanel_unit.point);
btn_b = new ReflexUI(); btn_b.set_name("BtnB"); btn_b.set_width(90, flexpanel_unit.point);
btn_c = new ReflexUI(); btn_c.set_name("BtnC"); btn_c.set_width(90, flexpanel_unit.point);

// Right-side "profile"
profile = new ReflexUI();
profile.set_name("Profile");
profile.set_width(140, flexpanel_unit.point);

row_toolbar.add(btn_a);
row_toolbar.add(btn_b);
row_toolbar.add(btn_c);
row_toolbar.add(profile);

// A content row (horizontal split)
row_content = new ReflexHBoxContainer();
row_content.set_name("ContentRow");
row_content.set_separation(12);
row_content.set_alignment(0);
row_content.set_flex_grow(1);
row_content.set_flex_basis(0);

// Left column (vertical) unchanged
col_left = new ReflexVBoxContainer();
col_left.set_name("LeftCol");
col_left.set_separation(8);
col_left.set_width(220, flexpanel_unit.point);

// Add a few "items" to left col
for (var i = 0; i < 4; i++)
{
	var _item = new ReflexUI();
	_item.set_name("Item_" + string(i));
	_item.set_height(42, flexpanel_unit.point);
	col_left.add(_item);
}

// Main panel (fills remaining)
panel_main = new ReflexUI();
panel_main.set_name("MainPanel");
panel_main.set_flex_grow(1);
panel_main.set_flex_basis(0);

// FLOW container inside main panel (this is the demo target)
flow_main = new ReflexHFlowContainer();
flow_main.set_name("FlowMain");
flow_main.set_alignment(0); // begin
flow_main.set_separation(8);
flow_main.set_flex_grow(1);
flow_main.set_flex_basis(0);

// Fill flow with many items to force wrapping
for (var j = 0; j < 40; j++)
{
	var _chip = new ReflexUI();
	_chip.set_name("Chip_" + string(j));

	// Vary widths to make wrapping obvious
	if ((j mod 3) == 0) { _chip.set_width(90, flexpanel_unit.point); }
	else if ((j mod 3) == 1) { _chip.set_width(130, flexpanel_unit.point); }
	else { _chip.set_width(170, flexpanel_unit.point); }

	_chip.set_height(36, flexpanel_unit.point);
	flow_main.add(_chip);
}

panel_main.add(flow_main);

// Assemble content row
row_content.add(col_left);
row_content.add(panel_main);

// Add to root
ui_root.add(row_toolbar);
ui_root.add(row_content);

// Attach to UI layer
ui_root.add_to("ReflexLayer");

// Demo state
demo_time = 0;
demo_reverse_fill = false;
demo_vertical_flow = false;