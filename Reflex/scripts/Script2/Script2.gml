/// Feather ignore all
#region jsDoc
/// @desc Measure function used to test set_measure_function.
#endregion
function reflex_test_measure(_width_value, _width_type, _height_value, _height_type)
{
	return { width: 64, height: 24 };
}

#region jsDoc
/// @desc Struct/array safe equality. Uses json_stringify for struct/array.
/// @returns {Bool}
#endregion
function reflex_test_equal(_left_value, _right_value)
{
	if (is_struct(_left_value) && is_struct(_right_value))
	{
		return json_stringify(_left_value) == json_stringify(_right_value);
	}

	if (is_array(_left_value) && is_array(_right_value))
	{
		return json_stringify(_left_value) == json_stringify(_right_value);
	}

	return string(_left_value) == string(_right_value);
}

#region jsDoc
/// @desc Capture every getter output from a reflex instance into a struct.
/// @returns {Struct}
#endregion
function reflex_test_capture(_node_wrap)
{
	var _capture = {};

	_capture.layout_position = _node_wrap.get_layout_position();
	_capture.data = _node_wrap.get_data();
	_capture.struct_data = _node_wrap.get_struct();

	// Style unit-value struct getters (live in your current wrapper)
	_capture.width = _node_wrap.get_width();
	_capture.height = _node_wrap.get_height();
	_capture.min_width = _node_wrap.get_min_width();
	_capture.max_width = _node_wrap.get_max_width();
	_capture.min_height = _node_wrap.get_min_height();
	_capture.max_height = _node_wrap.get_max_height();
	_capture.flex_basis = _node_wrap.get_flex_basis();

	// Edge based unit-value struct getters
	_capture.margin = array_create(9, undefined);
	_capture.padding = array_create(9, undefined);
	_capture.border = array_create(9, undefined);
	_capture.position_inset = array_create(9, undefined);

	for (var i = 0; i <= flexpanel_edge.all_edges; i++)
	{
		_capture.margin[i] = _node_wrap.get_margin(i);
		_capture.padding[i] = _node_wrap.get_padding(i);
		_capture.border[i] = _node_wrap.get_border(i);
		_capture.position_inset[i] = _node_wrap.get_position(i);
	}

	// Non-struct style getters
	_capture.align_content = _node_wrap.get_align_content();
	_capture.align_items = _node_wrap.get_align_items();
	_capture.align_self = _node_wrap.get_align_self();
	_capture.aspect_ratio = _node_wrap.get_aspect_ratio();
	_capture.display = _node_wrap.get_display();
	_capture.flex = _node_wrap.get_flex();
	_capture.flex_wrap = _node_wrap.get_flex_wrap();
	_capture.flex_grow = _node_wrap.get_flex_grow();
	_capture.flex_shrink = _node_wrap.get_flex_shrink();
	_capture.flex_direction = _node_wrap.get_flex_direction();
	_capture.justify_content = _node_wrap.get_justify_content();
	_capture.direction = _node_wrap.get_direction();
	_capture.position_type = _node_wrap.get_position_type();
	_capture.gap_all = _node_wrap.get_gap(flexpanel_gutter.all_gutters);
	_capture.gap_row = _node_wrap.get_gap(flexpanel_gutter.row);
	_capture.gap_column = _node_wrap.get_gap(flexpanel_gutter.column);

	// Tree/node info getters
	_capture.num_children = _node_wrap.get_num_children();
	_capture.parent = _node_wrap.get_parent();
	_capture.name = _node_wrap.get_name();
	_capture.measure_function = _node_wrap.get_measure_function();

	if (_capture.num_children > 0)
	{
		_capture.child_0 = _node_wrap.get_child(0);
	}
	else
	{
		_capture.child_0 = undefined;
	}

	_capture.child_hash_by_name = _node_wrap.get_child_hash("inner");

	return _capture;
}

#region jsDoc
/// @desc Compare two capture structs and print detailed debug output.
/// @returns {Real} number of changed keys
#endregion
function reflex_test_compare(_label_text, _before_state, _after_state)
{
	show_debug_message("------------------------------------------------------------");
	show_debug_message("reflex_test_compare: " + _label_text);

	var _keys = [
		"layout_position","data","struct_data",
		"width","height","min_width","max_width","min_height","max_height","flex_basis",
		"margin","padding","border","position_inset",
		"align_content","align_items","align_self","aspect_ratio","display","flex","flex_wrap",
		"flex_grow","flex_shrink","flex_direction","justify_content","direction","position_type",
		"gap_all","gap_row","gap_column",
		"num_children","child_0","child_hash_by_name","parent","name","measure_function"
	];

	var _changed_count = 0;

	for (var i = 0; i < array_length(_keys); i++)
	{
		var _key = _keys[i];
		var _left_value = _before_state[$ _key];
		var _right_value = _after_state[$ _key];

		if (!reflex_test_equal(_left_value, _right_value))
		{
			_changed_count += 1;
			show_debug_message("CHANGED: " + _key);
			show_debug_message("	before: " + json_stringify(_left_value));
			show_debug_message("	after : " + json_stringify(_right_value));
		}
	}

	if (_changed_count == 0)
	{
		show_debug_message("No changes detected across any getter outputs.");
	}
	else
	{
		show_debug_message("Total changed getter outputs: " + string(_changed_count));
	}

	return _changed_count;
}

#region jsDoc
/// @desc
///		Builds Outer -> Inner -> Leaf, commits an initial reflow, captures baseline,
///		resizes outer container + stretch-related settings, reflows, captures after, compares.
///		Measure function is only set on Leaf (must be a leaf node).
#endregion
function reflex_test_run()
{
	show_debug_message("============================================================");
	show_debug_message("reflex_test_run: begin");

	var _outer = new Reflex();
	var _inner = new Reflex();
	var _leaf = new Reflex();

	_outer.set_name("outer");
	_inner.set_name("inner");
	_leaf.set_name("leaf");

	_outer.add(_inner);
	_inner.add(_leaf);

	// ----------------------------
	// Call every setter at least once (distributed)
	// ----------------------------

	// outer: container-ish + stretching knobs
	_outer.set_align_content(flexpanel_align.stretch);
	_outer.set_align_items(flexpanel_align.stretch);
	_outer.set_align_self(flexpanel_align.auto);
	_outer.set_aspect_ratio(0);
	_outer.set_display(flexpanel_display.flex);
	_outer.set_flex(0);
	_outer.set_flex_wrap(flexpanel_wrap.wrap);
	_outer.set_flex_grow(0);
	_outer.set_flex_shrink(1);
	_outer.set_flex_basis(0, flexpanel_unit.auto);
	_outer.set_flex_direction(flexpanel_flex_direction.row);
	_outer.set_gap(flexpanel_gutter.all_gutters, 6);
	_outer.set_position_type(flexpanel_position_type.relative);
	_outer.set_position(flexpanel_edge.left, 0, flexpanel_unit.point);
	_outer.set_justify_content(flexpanel_justify.space_between);
	_outer.set_direction(flexpanel_direction.LTR);
	_outer.set_margin(flexpanel_edge.all_edges, 0, flexpanel_unit.point);
	_outer.set_padding(flexpanel_edge.all_edges, 8, flexpanel_unit.point);
	_outer.set_border(flexpanel_edge.all_edges, 0);
	_outer.set_min_width(0, flexpanel_unit.point);
	_outer.set_max_width(100, flexpanel_unit.percent);
	_outer.set_min_height(0, flexpanel_unit.point);
	_outer.set_max_height(100, flexpanel_unit.percent);
	_outer.set_width(100, flexpanel_unit.percent);
	_outer.set_height(100, flexpanel_unit.percent);

	// inner: explicitly fixed width so layout changes should be positional, not style
	_inner.set_align_content(flexpanel_align.stretch);
	_inner.set_align_items(flexpanel_align.stretch);
	_inner.set_align_self(flexpanel_align.stretch);
	_inner.set_aspect_ratio(1);
	_inner.set_display(flexpanel_display.flex);
	_inner.set_flex(0);
	_inner.set_flex_wrap(flexpanel_wrap.no_wrap);
	_inner.set_flex_grow(0);
	_inner.set_flex_shrink(0);
	_inner.set_flex_basis(0, flexpanel_unit.auto);
	_inner.set_flex_direction(flexpanel_flex_direction.row);
	_inner.set_gap(flexpanel_gutter.all_gutters, 4);
	_inner.set_position_type(flexpanel_position_type.relative);
	_inner.set_position(flexpanel_edge.left, 0, flexpanel_unit.point);
	_inner.set_justify_content(flexpanel_justify.start);
	_inner.set_direction(flexpanel_direction.LTR);
	_inner.set_margin(flexpanel_edge.all_edges, 4, flexpanel_unit.point);
	_inner.set_padding(flexpanel_edge.all_edges, 4, flexpanel_unit.point);
	_inner.set_border(flexpanel_edge.all_edges, 1);
	_inner.set_min_width(0, flexpanel_unit.point);
	_inner.set_max_width(9999, flexpanel_unit.point);
	_inner.set_min_height(0, flexpanel_unit.point);
	_inner.set_max_height(9999, flexpanel_unit.point);
	_inner.set_width(100, flexpanel_unit.point);
	_inner.set_height(40, flexpanel_unit.point);

	// leaf: absolute positioning + measure function (leaf-only)
	_leaf.set_measure_function(reflex_test_measure);
	_leaf.set_align_content(flexpanel_align.stretch);
	_leaf.set_align_items(flexpanel_align.stretch);
	_leaf.set_align_self(flexpanel_align.auto);
	_leaf.set_aspect_ratio(0);
	_leaf.set_display(flexpanel_display.flex);
	_leaf.set_flex(0);
	_leaf.set_flex_wrap(flexpanel_wrap.no_wrap);
	_leaf.set_flex_grow(0);
	_leaf.set_flex_shrink(0);
	_leaf.set_flex_basis(0, flexpanel_unit.auto);
	_leaf.set_flex_direction(flexpanel_flex_direction.row);
	_leaf.set_gap(flexpanel_gutter.all_gutters, 0);
	_leaf.set_position_type(flexpanel_position_type.absolute);
	_leaf.set_position(flexpanel_edge.left, 10, flexpanel_unit.point);
	_leaf.set_position(flexpanel_edge.top, 10, flexpanel_unit.point);
	_leaf.set_justify_content(flexpanel_justify.start);
	_leaf.set_direction(flexpanel_direction.LTR);
	_leaf.set_margin(flexpanel_edge.all_edges, 0, flexpanel_unit.point);
	_leaf.set_padding(flexpanel_edge.all_edges, 0, flexpanel_unit.point);
	_leaf.set_border(flexpanel_edge.all_edges, 0);
	_leaf.set_min_width(0, flexpanel_unit.point);
	_leaf.set_max_width(9999, flexpanel_unit.point);
	_leaf.set_min_height(0, flexpanel_unit.point);
	_leaf.set_max_height(9999, flexpanel_unit.point);
	_leaf.set_width(20, flexpanel_unit.point);
	_leaf.set_height(20, flexpanel_unit.point);

	// ----------------------------
	// Commit initial reflow so caches are non-null, then capture baseline
	// ----------------------------
	show_debug_message("reflex_test_run: commit initial reflow");
	_outer.request_reflow();
	_outer.attempt_reflow(0, 0, 400, 200, flexpanel_direction.LTR, true);

	show_debug_message("reflex_test_run: capture baseline (before resize)");
	var _outer_before = reflex_test_capture(_outer);
	var _inner_before = reflex_test_capture(_inner);
	var _leaf_before = reflex_test_capture(_leaf);

	// ----------------------------
	// Modify outer only (container resize + stretch-related knobs), then reflow and compare
	// ----------------------------
	show_debug_message("reflex_test_run: apply outer-only changes + resize");
	_outer.set_align_items(flexpanel_align.stretch);
	_outer.set_align_content(flexpanel_align.stretch);
	_outer.set_justify_content(flexpanel_justify.space_around);
	_outer.set_flex_wrap(flexpanel_wrap.wrap);

	_outer.request_reflow();
	_outer.attempt_reflow(0, 0, 800, 300, flexpanel_direction.LTR, false);

	show_debug_message("reflex_test_run: capture after resize");
	var _outer_after = reflex_test_capture(_outer);
	var _inner_after = reflex_test_capture(_inner);
	var _leaf_after = reflex_test_capture(_leaf);

	reflex_test_compare("OUTER after resize reflow", _outer_before, _outer_after);
	reflex_test_compare("INNER after resize reflow", _inner_before, _inner_after);
	reflex_test_compare("LEAF after resize reflow", _leaf_before, _leaf_after);

	show_debug_message("reflex_test_run: done");
	show_debug_message("============================================================");
}

reflex_test_run();