show_debug_overlay(true);

// Root container (vertical)
ui_root = new ReflexVBoxContainer();
ui_root.set_name("UIRoot");
ui_root.set_separation(12);
ui_root.set_padding(flexpanel_edge.all_edges, 16, flexpanel_unit.point);

// A top "toolbar" row
row_toolbar = new ReflexHBoxContainer();
row_toolbar.set_name("Toolbar");
row_toolbar.set_separation(8);
row_toolbar.set_alignment(0); // begin
row_toolbar.set_height(56, flexpanel_unit.point);

// Three "buttons" (just plain nodes for debug)
btn_a = new ReflexUI(); btn_a.set_name("BtnA"); btn_a.set_width(90, flexpanel_unit.point);
btn_b = new ReflexUI(); btn_b.set_name("BtnB"); btn_b.set_width(90, flexpanel_unit.point);
btn_c = new ReflexUI(); btn_c.set_name("BtnC"); btn_c.set_width(90, flexpanel_unit.point);

// Spacer to push right-side controls
//spacer = row_toolbar.add_spacer(false);

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
row_content.set_alignment(0); // begin
row_content.set_flex_grow(1);
row_content.set_flex_basis(0);

// Left column (vertical)
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

// Assemble content row
row_content.add(col_left);
row_content.add(panel_main);

// Add to root
ui_root.add(row_toolbar);
ui_root.add(row_content);

// Attach to UI layer (expects a UI layer named "ReflexLayer")
ui_root.add_to("ReflexLayer");

// demo time
demo_time = 0;