// ============================================================================
// obj_reflex_container_demo2
// Uses:
// - ReflexCenterContainer
// - ReflexMarginContainer
// - ReflexPaddingContainer
// - ReflexPanelContainer (spr_rect_round_all_8)
// - ReflexAspectRatioContainer (spr_test)
// Rendering: draw_debug() only
//
// Controls:
//  1: Toggle CenterContainer use_top_left
//  2: Cycle Panel padding (inner inset via PaddingContainer)
//  3: Cycle Panel margin (outer spacing via MarginContainer)
//  4: Cycle Aspect stretch_mode (0..3)
//  5: Cycle Aspect horizontal alignment (0..2)
//  6: Cycle Aspect vertical alignment (0..2)
//  Space: Toggle showing labels in draw_debug
// ============================================================================

ui_root = new ReflexVBoxContainer();
ui_root.set_name("DemoRoot");
ui_root.set_separation(12);
ui_root.set_padding(flexpanel_edge.all_edges, 12, flexpanel_unit.point);

// Attach to UI layer named "ReflexLayer"
ui_root.add_to("ReflexLayer");

// -----------------------------------------------------------------------------
// Row 1: CenterContainer showcase
// -----------------------------------------------------------------------------
row_center = new ReflexPanelContainer();
row_center.set_name("Panel-Center");
row_center.set_panel_sprite(spr_rect_round_all_8, 0);
row_center.set_padding(flexpanel_edge.all_edges, 10, flexpanel_unit.point);

center_wrap = new ReflexCenterContainer();
center_wrap.set_name("CenterContainer");
center_wrap.set_height(140, flexpanel_unit.point);
center_wrap.set_width(100, flexpanel_unit.percent);

center_target = new ReflexUI();
center_target.set_name("CenteredChild");
center_target.set_width(120, flexpanel_unit.point);
center_target.set_height(60, flexpanel_unit.point);

center_wrap.add(center_target);
row_center.add(center_wrap);

// -----------------------------------------------------------------------------
// Row 2: Margin + Padding containers showcase
// MarginContainer = outer space (set_margin)
// PaddingContainer = inner inset (set_padding)
// -----------------------------------------------------------------------------
row_insets = new ReflexHBoxContainer();
row_insets.set_name("InsetsRow");
row_insets.set_separation(12);
row_insets.set_min_height(170, flexpanel_unit.point);

margin_box = new ReflexMarginContainer();
margin_box.set_name("MarginContainer (outer)");
margin_box.set_width(50, flexpanel_unit.percent);
margin_box.set_height(170, flexpanel_unit.point);

padding_box = new ReflexPaddingContainer();
padding_box.set_name("PaddingContainer (inner)");
padding_box.set_width(100, flexpanel_unit.percent);
padding_box.set_height(170, flexpanel_unit.point);

// Put a panel inside to make inset obvious
panel_inset = new ReflexPanelContainer();
panel_inset.set_name("InsetPanel");
panel_inset.set_panel_sprite(spr_rect_round_all_8, 0);
panel_inset.set_width(100, flexpanel_unit.percent);
panel_inset.set_height(100, flexpanel_unit.percent);

padding_box.add(panel_inset);
margin_box.add(padding_box);
row_insets.add(margin_box);

// A second side panel to compare baseline
baseline_panel = new ReflexPanelContainer();
baseline_panel.set_name("BaselinePanel");
baseline_panel.set_panel_sprite(spr_rect_round_all_8, 0);
baseline_panel.set_width(50, flexpanel_unit.percent);
baseline_panel.set_height(100, flexpanel_unit.percent);

row_insets.add(baseline_panel);

// -----------------------------------------------------------------------------
// Row 3: AspectRatioContainer showcase
// -----------------------------------------------------------------------------
row_aspect = new ReflexPanelContainer();
row_aspect.set_name("Panel-Aspect");
row_aspect.set_panel_sprite(spr_rect_round_all_8, 0);
row_aspect.set_padding(flexpanel_edge.all_edges, 10, flexpanel_unit.point);
row_aspect.set_width(300, flexpanel_unit.point);
row_aspect.set_height(100, flexpanel_unit.point);

aspect_wrap = new ReflexAspectRatioContainer();
aspect_wrap.set_name("AspectRatioContainer");
aspect_wrap.set_width(100, flexpanel_unit.percent);
aspect_wrap.set_height(100, flexpanel_unit.percent);

// Sprite to visualize ratio
aspect_sprite = new ReflexLeafSprite(spr_test, 0);
aspect_sprite.set_name("spr_test");
aspect_sprite.set_width(100, flexpanel_unit.percent);
aspect_sprite.set_height(100, flexpanel_unit.percent);

// Default settings
aspect_wrap.set_ratio(16/9);
aspect_wrap.set_stretch_mode(2); // fit
aspect_wrap.set_alignment_horizontal(1);
aspect_wrap.set_alignment_vertical(1);

aspect_wrap.add(aspect_sprite);
row_aspect.add(aspect_wrap);

// -----------------------------------------------------------------------------
// Assemble root
// -----------------------------------------------------------------------------
ui_root.add(row_center);
ui_root.add(row_insets);
ui_root.add(row_aspect);

// -----------------------------------------------------------------------------
// Demo state
// -----------------------------------------------------------------------------
demo_show_labels = true;

demo_center_top_left = false;

demo_padding_index = 0;
demo_padding_list = [0, 8, 16, 24];

demo_margin_index = 0;
demo_margin_list = [0, 8, 16, 24];

demo_stretch_mode = 2;
demo_align_h = 1;
demo_align_v = 1;