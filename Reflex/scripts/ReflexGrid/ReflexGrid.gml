#region jsDoc
/// @func ReflexGrid
/// @desc
///		ReflexGrid - grid container built on Reflex + flex panels.
///		.
///		Goals:
///		- Uses flex panels only: children are positioned via absolute left/top/width/height in points.
///		- Supports both:
///		- 1) Cell addressed placement: set_cell(x,y,node), set_span(node,x1,y1,x2,y2)
///		- 2) Auto placement for add/insert using sparse packing (first slot that fits)
///		.
///		Counts model:
///		- This implementation is count-based (no templates like from from css).
///		- If counts are not explicitly set, auto grid may compute counts from sqrt(child_count).
///		.
///		Alignment model:
///		- Default per-cell alignment is controlled by set_cell_align(horz, vert).
///		- horz and vert accept: "start", "center", "end", "stretch".
///		- "stretch" forces the node to match the cell size on that axis.
///
#endregion
function ReflexGrid() : Reflex() constructor
{
	// -------------------------------------------------------------------------
	// Public API
	// -------------------------------------------------------------------------

	#region jsDoc
	/// @desc Sets the pixel solve-space for the grid.
	///       If not set, the grid falls back to cached layout size when available.
	/// @param {Real} _w
	/// @param {Real} _h
	/// @returns {ReflexGrid}
	#endregion
	static set_grid_size = function(_w, _h)
	{
		__grid_size_w = max(0, _w);
		__grid_size_h = max(0, _h);
		__grid_has_size = true;

		__grid_apply_auto_placement();
		request_reflow();
		return self;
	};

	#region jsDoc
	/// @desc Sets grid gaps in pixels.
	/// @param {Real} _v Vertical gap (row gap)
	/// @param {Real} _h Horizontal gap (column gap)
	/// @returns {ReflexGrid}
	#endregion
	static set_grid_gap = function(_v, _h)
	{
		__grid_gapy = max(0, _v);
		__grid_gapx = max(0, _h);

		__grid_apply_auto_placement();
		request_reflow();
		return self;
	};

	#region jsDoc
	/// @desc Sets grid auto flow for auto placement.
	/// @param {String} _flow_value "row" or "column"
	/// @returns {ReflexGrid}
	#endregion
	static set_grid_auto_flow = function(_flow_value)
	{
		__grid_auto_flow = (_flow_value == "column") ? "column" : "row";

		__grid_apply_auto_placement();
		request_reflow();
		return self;
	};

	#region jsDoc
	/// @desc Enables or disables auto-grid count computation when counts are not explicitly set.
	/// @param {Bool} _enabled
	/// @returns {ReflexGrid}
	#endregion
	static set_auto_grid = function(_enabled)
	{
		__grid_auto_grid = (_enabled == true);

		__grid_apply_auto_placement();
		request_reflow();
		return self;
	};

	#region jsDoc
	/// @desc Sets explicit grid counts. This disables auto count computation until changed again.
	/// @param {Real} _cols
	/// @param {Real} _rows
	/// @returns {ReflexGrid}
	#endregion
	static set_grid_counts = function(_cols, _rows)
	{
		__grid_col_count = max(1, floor(_cols));
		__grid_row_count = max(1, floor(_rows));
		__grid_counts_explicit = true;

		__grid_set_track_counts(__grid_col_count, __grid_row_count);

		__grid_apply_auto_placement();
		request_reflow();
		return self;
	};

	#region jsDoc
	/// @desc Returns the resolved row count.
	/// @returns {Real}
	#endregion
	static get_row_count = function()
	{
		__grid_ensure_template();
		return __grid_row_count;
	};

	#region jsDoc
	/// @desc Returns the resolved column count.
	/// @returns {Real}
	#endregion
	static get_col_count = function()
	{
		__grid_ensure_template();
		return __grid_col_count;
	};

	#region jsDoc
	/// @desc Sets default alignment for content inside each cell.
	/// @param {String} default_horz "start"|"center"|"end"|"stretch"
	/// @param {String} default_vert "start"|"center"|"end"|"stretch"
	/// @returns {ReflexGrid}
	#endregion
	static set_cell_align = function(default_horz, default_vert)
	{
		__grid_align_horz = __grid_sanitize_align(default_horz);
		__grid_align_vert = __grid_sanitize_align(default_vert);

		__grid_apply_auto_placement();
		request_reflow();
		return self;
	};

	#region jsDoc
	/// @desc
	///		Sets an explicit span and anchor cell for a node.
	///		Coordinates are inclusive: (x1,y1) to (x2,y2).
	/// @param {Reflex} _node
	/// @param {Real} _x1
	/// @param {Real} _y1
	/// @param {Real} _x2
	/// @param {Real} _y2
	/// @returns {ReflexGrid}
	#endregion
	static set_span = function(_node, _x1, _y1, _x2, _y2)
	{
		if (_node == undefined) { return self; }

		var _sx = floor(min(_x1, _x2));
		var _sy = floor(min(_y1, _y2));
		var _ex = floor(max(_x1, _x2));
		var _ey = floor(max(_y1, _y2));

		var _w = max(1, (_ex - _sx) + 1);
		var _h = max(1, (_ey - _sy) + 1);

		__grid_span_set_fixed(_node, _sx, _sy, _w, _h);

		// Ensure it is parented to this grid
		if (_node.__parent != self)
		{
			insert(_node, -1);
		}

		__grid_apply_auto_placement();
		request_reflow();
		return self;
	};

	#region jsDoc
	/// @desc Sets an explicit cell anchor (span defaults to 1x1).
	/// @param {Real} _x
	/// @param {Real} _y
	/// @param {Reflex} reflex
	/// @returns {ReflexGrid}
	#endregion
	static set_cell = function(_x, _y, reflex)
	{
		if (reflex == undefined) { return self; }

		var _cx = floor(_x);
		var _cy = floor(_y);

		__grid_span_set_fixed(reflex, _cx, _cy, 1, 1);

		if (reflex.__parent != self)
		{
			insert(reflex, -1);
		}

		__grid_apply_auto_placement();
		request_reflow();
		return self;
	};

	#region jsDoc
	/// @desc Returns the node anchored at (x,y), if any.
	/// @param {Real} _x
	/// @param {Real} _y
	/// @returns {Reflex|Undefined}
	#endregion
	static get_cell = function(_x, _y)
	{
		var _key = __grid_cell_key(floor(_x), floor(_y));
		return __grid_cell_map[$ _key];
	};

	#region jsDoc
	/// @desc
	///		Clears the placement of the node occupying (x,y).
	///		If the cell is inside a spanned region, this clears that node's whole placement.
	/// @param {Real} _x
	/// @param {Real} _y
	/// @returns {ReflexGrid}
	#endregion
	static clear_cell = function(_x, _y)
	{
		var _cx = floor(_x);
		var _cy = floor(_y);

		var _node = __grid_find_node_at_cell(_cx, _cy);
		if (_node == undefined) { return self; }

		__grid_span_clear_fixed(_node);

		__grid_apply_auto_placement();
		request_reflow();
		return self;
	};

	#region jsDoc
	/// @desc Sets a node's auto-placement span (no fixed cell). This is used by auto packing.
	/// @param {Reflex} _node
	/// @param {Real} _col_span
	/// @param {Real} _row_span
	/// @returns {ReflexGrid}
	#endregion
	static set_grid_span = function(_node, _col_span=1, _row_span=1)
	{
		if (_node == undefined) { return self; }

		var _idx = __grid_span_get_index(_node);
		if (_idx < 0) { return self; }

		__grid_span_records[_idx].col_span = max(1, floor(_col_span));
		__grid_span_records[_idx].row_span = max(1, floor(_row_span));

		__grid_apply_auto_placement();
		request_reflow();
		return self;
	};

	// -------------------------------------------------------------------------
	// Override: child management (grid placement is based on insertion order)
	// -------------------------------------------------------------------------

	#region jsDoc
	/// @desc Adds a node (append). If the node has no fixed placement, it will be auto-placed.
	/// @param {Reflex} _node
	#endregion
	static add = function(_node)
	{
		static __base_add = Reflex.add;
		__base_add(_node);

		__grid_span_get_index(_node);

		__grid_apply_auto_placement();
		request_reflow();
	};

	#region jsDoc
	/// @desc Inserts a node. If the node has no fixed placement, it will be auto-placed.
	/// @param {Reflex} _node
	/// @param {Real} _index
	#endregion
	static insert = function(_node, _index=-1)
	{
		// Let base Reflex do the flexpanel insert + wrapper links + request_reflow
		static __base_insert = Reflex.insert;
		__base_insert(_node, _index);

		__grid_span_get_index(_node);

		__grid_apply_auto_placement();
		request_reflow();
	};

	#region jsDoc
	/// @desc Removes a node from this grid and clears any stored placement info for it.
	/// @param {Reflex} _node
	#endregion
	static remove = function(_node)
	{
		if (_node == undefined) { return; }

		__grid_span_remove(_node);

		// Clear any explicit cell mapping entries pointing at this node
		__grid_cells_remove_node(_node);

		static __base_remove = Reflex.remove;
		__base_remove(_node);

		__grid_apply_auto_placement();
		request_reflow();
	};

	#region jsDoc
	/// @desc Clears all nodes and all grid metadata.
	#endregion
	static clear = function()
	{
		array_resize(__grid_span_records, 0);
		__grid_cell_map = {};

		static __base_clear = Reflex.clear;
		__base_clear(true);

		__grid_apply_auto_placement();
		request_reflow();
	};

	#region Private
	
	// -------------------------------------------------------------------------
	// Grid State
	// -------------------------------------------------------------------------
	__grid_gapx = 0;
	__grid_gapy = 0;

	__grid_has_size = false;
	__grid_size_w = 0;
	__grid_size_h = 0;

	// "row" or "column"
	__grid_auto_flow = "row";

	// If true and counts are not explicitly set, counts are computed from sqrt(child_count)
	__grid_auto_grid = true;

	// If true, user explicitly set counts (we keep them stable)
	__grid_counts_explicit = false;

	__grid_col_count = 0;
	__grid_row_count = 0;

	// Track arrays are maintained as 1fr per column/row (count-based grid)
	__grid_cols = [];
	__grid_rows = [];

	__grid_col_sizes = [];
	__grid_row_sizes = [];
	__grid_col_offsets = [];
	__grid_row_offsets = [];

	// Default cell alignment
	__grid_align_horz = "stretch";
	__grid_align_vert = "stretch";

	// Explicit placements by cell (ds_grid-like)
	// Stores only the anchor cell for an explicitly placed node.
	// Key: "x,y" -> node
	__grid_cell_map = {};

	// For spans (and for auto placement sizing), stored per node
	// Each record: { node, col_span, row_span, has_fixed, col, row }
	__grid_span_records = [];
	
	
	// -------------------------------------------------------------------------
	// Private helpers (segmented at bottom as requested)
	// -------------------------------------------------------------------------
	#region jsDoc
	/// @desc Sanitizes an alignment token.
	/// @param {Any} _value
	/// @returns {String} "start"|"center"|"end"|"stretch"
	#endregion
	static __grid_sanitize_align = function(_value)
	{
		if (_value == "start") { return "start"; }
		if (_value == "center") { return "center"; }
		if (_value == "end") { return "end"; }
		if (_value == "stretch") { return "stretch"; }
		return "stretch";
	};

	#region jsDoc
	/// @desc Generates a struct key for a cell coordinate.
	/// @param {Real} _x
	/// @param {Real} _y
	/// @returns {String}
	#endregion
	static __grid_cell_key = function(_x, _y)
	{
		return string(_x) + "," + string(_y);
	};

	#region jsDoc
	/// @desc Removes any cell-map entries that point to a node.
	/// @param {Reflex} _node
	#endregion
	static __grid_cells_remove_node = function(_node)
	{
		if (_node == undefined) { return; }

		var _keys = variable_struct_get_names(__grid_cell_map);
		var _count = array_length(_keys);
		for (var i = 0; i < _count; i++)
		{
			var _key = _keys[i];
			if (__grid_cell_map[$ _key] == _node)
			{
				__grid_cell_map[$ _key] = undefined;
			}
		}
	};

	#region jsDoc
	/// @desc Finds the node that occupies a cell, including spans.
	/// @param {Real} _x
	/// @param {Real} _y
	/// @returns {Reflex|Undefined}
	#endregion
	static __grid_find_node_at_cell = function(_x, _y)
	{
		// Fast path: exact anchor cell
		var _key = __grid_cell_key(_x, _y);
		var _direct = __grid_cell_map[$ _key];
		if (_direct != undefined) { return _direct; }

		// Span scan: check fixed placements and their span rect
		var _count = array_length(__grid_span_records);
		for (var i = 0; i < _count; i++)
		{
			var _rec = __grid_span_records[i];
			if (!_rec.has_fixed) { continue; }

			if (_x < _rec.col) { continue; }
			if (_y < _rec.row) { continue; }
			if (_x >= (_rec.col + _rec.col_span)) { continue; }
			if (_y >= (_rec.row + _rec.row_span)) { continue; }

			return _rec.node;
		}

		return undefined;
	};

	#region jsDoc
	/// @desc Ensures count-based tracks exist. If not explicit, may compute from auto-grid.
	#endregion
	static __grid_ensure_template = function()
	{
		if (__grid_counts_explicit)
		{
			if (__grid_col_count <= 0) { __grid_col_count = 1; }
			if (__grid_row_count <= 0) { __grid_row_count = 1; }
			__grid_set_track_counts(__grid_col_count, __grid_row_count);
			return;
		}

		var _child_count = array_length(__children);
		if (_child_count <= 0)
		{
			__grid_col_count = 1;
			__grid_row_count = 1;
			__grid_set_track_counts(__grid_col_count, __grid_row_count);
			return;
		}

		if (__grid_auto_grid)
		{
			var _cols = ceil(sqrt(_child_count));
			var _rows = ceil(_child_count / _cols);

			__grid_col_count = max(1, _cols);
			__grid_row_count = max(1, _rows);
		}
		else
		{
			// Simple fallback if auto-grid disabled and no explicit counts:
			// row flow -> 1 column, N rows
			// column flow -> N columns, 1 row
			if (__grid_auto_flow == "column")
			{
				__grid_col_count = max(1, _child_count);
				__grid_row_count = 1;
			}
			else
			{
				__grid_col_count = 1;
				__grid_row_count = max(1, _child_count);
			}
		}

		__grid_set_track_counts(__grid_col_count, __grid_row_count);
	};

	#region jsDoc
	/// @desc Resizes track arrays to match counts (all 1fr).
	/// @param {Real} _cols
	/// @param {Real} _rows
	#endregion
	static __grid_set_track_counts = function(_cols, _rows)
	{
		array_resize(__grid_cols, 0);
		array_resize(__grid_rows, 0);

		for (var i = 0; i < _cols; i++)
		{
			array_push(__grid_cols, { mode: "fr", value: 1 });
		}

		for (var j = 0; j < _rows; j++)
		{
			array_push(__grid_rows, { mode: "fr", value: 1 });
		}
	};

	#region jsDoc
	/// @desc Resolves the container size used for grid calculations.
	///       If set_grid_size() has not been called, falls back to cached layout size when available.
	/// @returns {Struct} { w, h }
	#endregion
	static __grid_get_size = function()
	{
		if (__grid_has_size)
		{
			return { w: __grid_size_w, h: __grid_size_h };
		}

		var _layout = __cache_layout;
		if (_layout != undefined)
		{
			return { w: max(0, _layout.width), h: max(0, _layout.height) };
		}

		return { w: 0, h: 0 };
	};

	#region jsDoc
	/// @desc Finds or creates a span record for a child.
	/// @param {Reflex} _child_node
	/// @returns {Real} Index into __grid_span_records
	#endregion
	static __grid_span_get_index = function(_child_node)
	{
		if (_child_node == undefined) { return -1; }

		var _count = array_length(__grid_span_records);
		for (var i = 0; i < _count; i++)
		{
			if (__grid_span_records[i].node == _child_node)
			{
				return i;
			}
		}

		var _record = {
			node: _child_node,
			col_span: 1,
			row_span: 1,
			has_fixed: false,
			col: 0,
			row: 0
		};
		array_push(__grid_span_records, _record);
		return array_length(__grid_span_records) - 1;
	};

	#region jsDoc
	/// @desc Removes a span record for a child if present.
	/// @param {Reflex} _child_node
	#endregion
	static __grid_span_remove = function(_child_node)
	{
		if (_child_node == undefined) { return; }

		var _count = array_length(__grid_span_records);
		for (var i = 0; i < _count; i++)
		{
			if (__grid_span_records[i].node == _child_node)
			{
				array_delete(__grid_span_records, i, 1);
				return;
			}
		}
	};

	#region jsDoc
	/// @desc Reads a child's span record, defaulting to 1x1.
	/// @param {Reflex} _child_node
	/// @returns {Struct} { col_span, row_span, has_fixed, col, row }
	#endregion
	static __grid_span_get = function(_child_node)
	{
		var _count = array_length(__grid_span_records);
		for (var i = 0; i < _count; i++)
		{
			if (__grid_span_records[i].node == _child_node)
			{
				var _rec = __grid_span_records[i];
				return {
					col_span: max(1, _rec.col_span),
					row_span: max(1, _rec.row_span),
					has_fixed: (_rec.has_fixed == true),
					col: _rec.col,
					row: _rec.row
				};
			}
		}

		return { col_span: 1, row_span: 1, has_fixed: false, col: 0, row: 0 };
	};

	#region jsDoc
	/// @desc Sets a node fixed anchor and span. Also updates the cell-map for the anchor.
	/// @param {Reflex} _node
	/// @param {Real} _col
	/// @param {Real} _row
	/// @param {Real} _col_span
	/// @param {Real} _row_span
	#endregion
	static __grid_span_set_fixed = function(_node, _col, _row, _col_span, _row_span)
	{
		var _idx = __grid_span_get_index(_node);
		if (_idx < 0) { return; }

		__grid_span_records[_idx].has_fixed = true;
		__grid_span_records[_idx].col = floor(_col);
		__grid_span_records[_idx].row = floor(_row);
		__grid_span_records[_idx].col_span = max(1, floor(_col_span));
		__grid_span_records[_idx].row_span = max(1, floor(_row_span));

		var _key = __grid_cell_key(__grid_span_records[_idx].col, __grid_span_records[_idx].row);
		__grid_cell_map[$ _key] = _node;
	};

	#region jsDoc
	/// @desc Clears a node fixed anchor (it becomes auto-placeable).
	/// @param {Reflex} _node
	#endregion
	static __grid_span_clear_fixed = function(_node)
	{
		var _idx = __grid_span_get_index(_node);
		if (_idx < 0) { return; }

		if (__grid_span_records[_idx].has_fixed)
		{
			var _key = __grid_cell_key(__grid_span_records[_idx].col, __grid_span_records[_idx].row);
			if (__grid_cell_map[$ _key] == _node)
			{
				__grid_cell_map[$ _key] = undefined;
			}
		}

		__grid_span_records[_idx].has_fixed = false;
	};

	#region jsDoc
	/// @desc Checks if a span rectangle fits within bounds and does not overlap occupied cells.
	/// @param {Array} _occupied
	/// @param {Real} _col_count
	/// @param {Real} _row_count
	/// @param {Real} _col_start
	/// @param {Real} _row_start
	/// @param {Real} _col_span
	/// @param {Real} _row_span
	/// @returns {Bool}
	#endregion
	static __grid_can_place = function(_occupied, _col_count, _row_count, _col_start, _row_start, _col_span, _row_span)
	{
		if (_col_start < 0 || _row_start < 0) { return false; }
		if ((_col_start + _col_span) > _col_count) { return false; }
		if ((_row_start + _row_span) > _row_count) { return false; }

		for (var _row_value = _row_start; _row_value < (_row_start + _row_span); _row_value++)
		{
			var _base_index = _row_value * _col_count;
			for (var _col_value = _col_start; _col_value < (_col_start + _col_span); _col_value++)
			{
				if (_occupied[_base_index + _col_value]) { return false; }
			}
		}

		return true;
	};

	#region jsDoc
	/// @desc Marks occupied cells for a placed rectangle.
	/// @param {Array} _occupied
	/// @param {Real} _col_count
	/// @param {Real} _col_start
	/// @param {Real} _row_start
	/// @param {Real} _col_span
	/// @param {Real} _row_span
	#endregion
	static __grid_mark_place = function(_occupied, _col_count, _col_start, _row_start, _col_span, _row_span)
	{
		for (var _row_value = _row_start; _row_value < (_row_start + _row_span); _row_value++)
		{
			var _base_index = _row_value * _col_count;
			for (var _col_value = _col_start; _col_value < (_col_start + _col_span); _col_value++)
			{
				_occupied[_base_index + _col_value] = true;
			}
		}
	};

	#region jsDoc
	/// @desc Finds the first available slot for a span based on grid-auto-flow.
	/// @param {Array} _occupied
	/// @param {Real} _col_count
	/// @param {Real} _row_count
	/// @param {Real} _col_span
	/// @param {Real} _row_span
	/// @returns {Struct} { col, row, found }
	#endregion
	static __grid_find_slot = function(_occupied, _col_count, _row_count, _col_span, _row_span)
	{
		_col_span = clamp(_col_span, 1, _col_count);
		_row_span = clamp(_row_span, 1, _row_count);

		if (__grid_auto_flow == "column")
		{
			for (var _col_start = 0; _col_start < _col_count; _col_start++)
			{
				for (var _row_start = 0; _row_start < _row_count; _row_start++)
				{
					if (__grid_can_place(_occupied, _col_count, _row_count, _col_start, _row_start, _col_span, _row_span))
					{
						return { col: _col_start, row: _row_start, found: true };
					}
				}
			}
		}
		else
		{
			for (var _row_start2 = 0; _row_start2 < _row_count; _row_start2++)
			{
				for (var _col_start2 = 0; _col_start2 < _col_count; _col_start2++)
				{
					if (__grid_can_place(_occupied, _col_count, _row_count, _col_start2, _row_start2, _col_span, _row_span))
					{
						return { col: _col_start2, row: _row_start2, found: true };
					}
				}
			}
		}

		return { col: 0, row: 0, found: false };
	};

	#region jsDoc
	/// @desc Computes track sizes and offsets for a given total size.
	/// @param {Array} _tracks
	/// @param {Real} _total_size
	/// @param {Real} _gap_value
	/// @param {Array} _sizes_out
	/// @param {Array} _offsets_out
	#endregion
	static __grid_compute_tracks = function(_tracks, _total_size, _gap_value, _sizes_out, _offsets_out)
	{
		var _count = array_length(_tracks);
		if (_count <= 0) { return; }

		var _gap_total = (_count > 1) ? (_gap_value * (_count - 1)) : 0;
		var _usable = max(0, _total_size - _gap_total);

		var _fixed_total = 0;
		var _frac_total = 0;

		for (var _i = 0; _i < _count; _i++)
		{
			var _track = _tracks[_i];
			if (_track.mode == "px")
			{
				_fixed_total += max(0, _track.value);
			}
			else
			{
				_frac_total += max(0, _track.value);
			}
		}

		var _remaining = max(0, _usable - _fixed_total);
		var _cursor = 0;

		for (var _j = 0; _j < _count; _j++)
		{
			var _track2 = _tracks[_j];
			var _size_value = 0;

			if (_track2.mode == "px")
			{
				_size_value = max(0, _track2.value);
			}
			else
			{
				_size_value = (_frac_total > 0) ? ((_remaining * max(0, _track2.value)) / _frac_total) : 0;
			}

			_sizes_out[_j] = _size_value;
			_offsets_out[_j] = _cursor;

			_cursor += _size_value;
			if (_j < _count - 1)
			{
				_cursor += _gap_value;
			}
		}
	};

	#region jsDoc
	/// @desc Applies sparse placement (fixed cells first, then auto) and writes absolute styles to children.
	#endregion
	static __grid_apply_auto_placement = function()
	{
		__grid_ensure_template();

		var _size_struct = __grid_get_size();
		var _width_value = _size_struct.w;
		var _height_value = _size_struct.h;

		var _col_count = __grid_col_count;
		var _row_count = __grid_row_count;

		if (_col_count <= 0 || _row_count <= 0) { return; }

		__grid_compute_tracks(__grid_cols, _width_value, __grid_gapx, __grid_col_sizes, __grid_col_offsets);
		__grid_compute_tracks(__grid_rows, _height_value, __grid_gapy, __grid_row_sizes, __grid_row_offsets);

		var _cell_total = _col_count * _row_count;
		var _occupied = array_create(_cell_total, false);

		// Pass 1: mark and place fixed nodes first
		var _rec_count = array_length(__grid_span_records);
		for (var r = 0; r < _rec_count; r++)
		{
			var _rec = __grid_span_records[r];
			if (!_rec.has_fixed) { continue; }
			if (_rec.node == undefined) { continue; }

			var _fx = clamp(_rec.col, 0, _col_count - 1);
			var _fy = clamp(_rec.row, 0, _row_count - 1);

			var _fsx = clamp(_rec.col_span, 1, _col_count);
			var _fsy = clamp(_rec.row_span, 1, _row_count);

			if ((_fx + _fsx) > _col_count) { _fsx = max(1, _col_count - _fx); }
			if ((_fy + _fsy) > _row_count) { _fsy = max(1, _row_count - _fy); }

			if (__grid_can_place(_occupied, _col_count, _row_count, _fx, _fy, _fsx, _fsy))
			{
				__grid_mark_place(_occupied, _col_count, _fx, _fy, _fsx, _fsy);
				__grid_apply_node_to_cell_rect(_rec.node, _fx, _fy, _fsx, _fsy);
			}
			else
			{
				// Overlap: place anyway into last cell as a fallback
				__grid_apply_node_to_cell_rect(_rec.node, _col_count - 1, _row_count - 1, 1, 1);
			}
		}

		// Pass 2: auto place remaining children in insertion order
		var _child_count = array_length(__children);
		for (var i = 0; i < _child_count; i++)
		{
			var _child_node = __children[i];
			if (_child_node == undefined) { continue; }

			var _span = __grid_span_get(_child_node);
			if (_span.has_fixed) { continue; }

			var _col_span = clamp(_span.col_span, 1, _col_count);
			var _row_span = clamp(_span.row_span, 1, _row_count);

			var _slot = __grid_find_slot(_occupied, _col_count, _row_count, _col_span, _row_span);

			var _cx = _slot.col;
			var _cy = _slot.row;

			if (!_slot.found)
			{
				_cx = _col_count - 1;
				_cy = _row_count - 1;
				_col_span = 1;
				_row_span = 1;
			}

			__grid_mark_place(_occupied, _col_count, _cx, _cy, _col_span, _row_span);
			__grid_apply_node_to_cell_rect(_child_node, _cx, _cy, _col_span, _row_span);
		}
	};

	#region jsDoc
	/// @desc Applies absolute styles to a node for a specific cell rectangle, with default alignment.
	/// @param {Reflex} _node
	/// @param {Real} _col
	/// @param {Real} _row
	/// @param {Real} _col_span
	/// @param {Real} _row_span
	#endregion
	static __grid_apply_node_to_cell_rect = function(_node, _col, _row, _col_span, _row_span)
	{
		var _col_last = clamp(_col + _col_span - 1, 0, __grid_col_count - 1);
		var _row_last = clamp(_row + _row_span - 1, 0, __grid_row_count - 1);

		var _x0 = __grid_col_offsets[_col];
		var _y0 = __grid_row_offsets[_row];

		var _x1 = __grid_col_offsets[_col_last] + __grid_col_sizes[_col_last];
		var _y1 = __grid_row_offsets[_row_last] + __grid_row_sizes[_row_last];

		var _cell_w = max(0, _x1 - _x0);
		var _cell_h = max(0, _y1 - _y0);

		var _node_w = _cell_w;
		var _node_h = _cell_h;

		if (__grid_align_horz != "stretch")
		{
			var _pref_w = max(0, _node.w);
			_node_w = (_pref_w > 0) ? min(_cell_w, _pref_w) : _cell_w;
		}

		if (__grid_align_vert != "stretch")
		{
			var _pref_h = max(0, _node.h);
			_node_h = (_pref_h > 0) ? min(_cell_h, _pref_h) : _cell_h;
		}

		var _off_x = 0;
		var _off_y = 0;

		if (__grid_align_horz == "center") { _off_x = (_cell_w - _node_w) * 0.5; }
		else if (__grid_align_horz == "end") { _off_x = (_cell_w - _node_w); }

		if (__grid_align_vert == "center") { _off_y = (_cell_h - _node_h) * 0.5; }
		else if (__grid_align_vert == "end") { _off_y = (_cell_h - _node_h); }

		_node.set_position_type(flexpanel_position_type.absolute);
		_node.set_position(flexpanel_edge.left, _x0 + _off_x, flexpanel_unit.point);
		_node.set_position(flexpanel_edge.top, _y0 + _off_y, flexpanel_unit.point);
		_node.set_width(_node_w, flexpanel_unit.point);
		_node.set_height(_node_h, flexpanel_unit.point);
	};

	#endregion
}