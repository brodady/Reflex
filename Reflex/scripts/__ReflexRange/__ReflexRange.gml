#region jsDoc
/// @func __ReflexRange()
/// @desc Abstract base for range-like UI controls (value within min/max with step and page).
///       Provides clamping, stepping, ratio mapping, and optional share groups.
/// @return {Struct.__ReflexRange}
#endregion
function __ReflexRange() : ReflexUI() constructor
{
	#region Setters

	#region jsDoc
	/// @func set_allow_greater(_value)
	/// @desc If true, value may exceed max_value.
	/// @param {Bool} _value
	/// @return {Struct.__ReflexRange}
	#endregion
	static set_allow_greater = function(_value)
	{
		if (allow_greater == _value) { return self; }
		allow_greater = _value;
		__changed();
		__apply_value(value, true);
		return self;
	};

	#region jsDoc
	/// @func set_allow_lesser(_value)
	/// @desc If true, value may go below min_value.
	/// @param {Bool} _value
	/// @return {Struct.__ReflexRange}
	#endregion
	static set_allow_lesser = function(_value)
	{
		if (allow_lesser == _value) { return self; }
		allow_lesser = _value;
		__changed();
		__apply_value(value, true);
		return self;
	};

	#region jsDoc
	/// @func set_exp_ratio(_value)
	/// @desc If true and min_value >= 0, ratio mapping is exponential.
	/// @param {Bool} _value
	/// @return {Struct.__ReflexRange}
	#endregion
	static set_exp_ratio = function(_value)
	{
		if (exp_edit == _value) { return self; }
		exp_edit = _value;
		__changed();
		__apply_value(value, true);
		return self;
	};

	#region jsDoc
	/// @func set_min(_value)
	/// @desc Sets the minimum value.
	/// @param {Real} _value
	/// @return {Struct.__ReflexRange}
	#endregion
	static set_min = function(_value)
	{
		if (min_value == _value) { return self; }
		min_value = _value;
		if (max_value < min_value) { max_value = min_value; }
		__changed();
		__apply_value(value, true);
		return self;
	};

	#region jsDoc
	/// @func set_max(_value)
	/// @desc Sets the maximum value.
	/// @param {Real} _value
	/// @return {Struct.__ReflexRange}
	#endregion
	static set_max = function(_value)
	{
		if (max_value == _value) { return self; }
		max_value = _value;
		if (max_value < min_value) { min_value = max_value; }
		__changed();
		__apply_value(value, true);
		return self;
	};

	#region jsDoc
	/// @func set_page(_value)
	/// @desc Sets the page size (used by scrollbars for grabber sizing).
	/// @param {Real} _value
	/// @return {Struct.__ReflexRange}
	#endregion
	static set_page = function(_value)
	{
		if (page == _value) { return self; }
		page = _value;
		__changed();
		__apply_value(value, true);
		return self;
	};

	#region jsDoc
	/// @func set_step(_value)
	/// @desc Sets step size. If > 0, value snaps to multiples of step above min_value.
	/// @param {Real} _value
	/// @return {Struct.__ReflexRange}
	#endregion
	static set_step = function(_value)
	{
		if (step == _value) { return self; }
		step = _value;
		__changed();
		__apply_value(value, true);
		return self;
	};

	#region jsDoc
	/// @func set_use_rounded_values(_value)
	/// @desc If true, value is rounded to nearest integer (after step snapping).
	/// @param {Bool} _value
	/// @return {Struct.__ReflexRange}
	#endregion
	static set_use_rounded_values = function(_value)
	{
		if (rounded == _value) { return self; }
		rounded = _value;
		__changed();
		__apply_value(value, true);
		return self;
	};

	#region jsDoc
	/// @func set_value(_value)
	/// @desc Sets the value and triggers value_changed.
	/// @param {Real} _value
	/// @return {Struct.__ReflexRange}
	#endregion
	static set_value = function(_value)
	{
		__apply_value(_value, false);
		return self;
	};

	#region jsDoc
	/// @func set_value_no_signal(_value)
	/// @desc Sets the value without emitting the value_changed callback.
	/// @param {Real} _value
	/// @return {Struct.__ReflexRange}
	#endregion
	static set_value_no_signal = function(_value)
	{
		__apply_value(_value, true);
		return self;
	};

	#region jsDoc
	/// @func set_as_ratio(_value)
	/// @desc Sets the value by ratio in [0..1].
	/// @param {Real} _value
	/// @return {Struct.__ReflexRange}
	#endregion
	static set_as_ratio = function(_value)
	{
		var _ratio = __clamp01(_value);
		var _mapped = __ratio_to_value(_ratio);
		__apply_value(_mapped, false);
		return self;
	};

	#region jsDoc
	/// @func share(_with)
	/// @desc Binds this range and another together (simple shared group).
	/// @param {Struct.__ReflexRange} _with
	/// @return {Struct.__ReflexRange}
	#endregion
	static share = function(_with)
	{
		if (_with == undefined) { return self; }
		if (_with == self) { return self; }

		if (__share_group == undefined) { __share_group = []; }
		if (_with.__share_group == undefined) { _with.__share_group = []; }

		__share_merge_groups(_with);
		__share_push_state();
		return self;
	};

	#region jsDoc
	/// @func unshare()
	/// @desc Removes this range from any share group.
	/// @return {Struct.__ReflexRange}
	#endregion
	static unshare = function()
	{
		if (__share_group == undefined) { return self; }
		
		var _index = array_get_index(__share_group, self);
		array_delete(__share_group, _index, 1);
		
		__share_group = undefined;
		return self;
	};

	#endregion

	#region Getters

	#region jsDoc
	/// @func is_greater_allowed()
	/// @desc Returns allow_greater.
	/// @return {Bool}
	#endregion
	static is_greater_allowed = function() { return allow_greater; };

	#region jsDoc
	/// @func is_lesser_allowed()
	/// @desc Returns allow_lesser.
	/// @return {Bool}
	#endregion
	static is_lesser_allowed = function() { return allow_lesser; };

	#region jsDoc
	/// @func is_ratio_exp()
	/// @desc Returns exp_edit.
	/// @return {Bool}
	#endregion
	static is_ratio_exp = function() { return exp_edit; };

	#region jsDoc
	/// @func get_min()
	/// @desc Returns min_value.
	/// @return {Real}
	#endregion
	static get_min = function() { return min_value; };

	#region jsDoc
	/// @func get_max()
	/// @desc Returns max_value.
	/// @return {Real}
	#endregion
	static get_max = function() { return max_value; };

	#region jsDoc
	/// @func get_page()
	/// @desc Returns page.
	/// @return {Real}
	#endregion
	static get_page = function() { return page; };

	#region jsDoc
	/// @func get_step()
	/// @desc Returns step.
	/// @return {Real}
	#endregion
	static get_step = function() { return step; };

	#region jsDoc
	/// @func is_using_rounded_values()
	/// @desc Returns rounded.
	/// @return {Bool}
	#endregion
	static is_using_rounded_values = function() { return rounded; };

	#region jsDoc
	/// @func get_value()
	/// @desc Returns value.
	/// @return {Real}
	#endregion
	static get_value = function() { return value; };

	#region jsDoc
	/// @func get_as_ratio()
	/// @desc Returns value mapped to ratio in [0..1].
	/// @return {Real}
	#endregion
	static get_as_ratio = function()
	{
		return __value_to_ratio(value);
	};

	#endregion
	
	#region Events
	events.changed = variable_get_hash("changed");
	events.value_changed = variable_get_hash("value_changed");
	
	#region jsDoc
	/// @func    on_changed()
	/// @desc    Adds a listener for when min_value, max_value, page, or step change.
	/// @self    __ReflexRange
	/// @param   {Function} func : Listener invoked when enabled.
	/// @returns {Struct.__ReflexRange}
	#endregion
	static on_changed = function(_func) {
		__add_event_listener(events.changed, _func);
		return self;
	}
	#region jsDoc
	/// @func    on_value_changed()
	/// @desc    Adds a listener for when value changes. When used on a Slider, this is called continuously while dragging (potentially every frame).
	/// @self    __ReflexRange
	/// @param   {Function} func : Listener invoked when disabled.
	/// @returns {Struct.__ReflexRange}
	#endregion
	static on_value_changed = function(_func) {
		__add_event_listener(events.value_changed, _func);
		return self;
	}
	
	#endregion
	
	#region Virtuals

	#region jsDoc
	/// @func _value_changed(_new_value)
	/// @desc Virtual hook called after value changes (and after callback).
	/// @param {Real} _new_value
	#endregion
	static _value_changed = function(_new_value)
	{
	};

	#endregion

	#region Private

	allow_greater = false;
	allow_lesser = false;
	exp_edit = false;

	min_value = 0.0;
	max_value = 100.0;
	page = 0.0;

	rounded = false;
	step = 0.01;

	value = 0.0;

	__share_group = undefined;
	
	#region Functions
	
	#region jsDoc
	/// @func __changed()
	/// @desc Fires changed callback and pushes share state.
	#endregion
	static __changed = function()
	{
		__trigger_event(events.changed);
		__share_push_state();
	};

	#region jsDoc
	/// @func __apply_value(_next_value, _quiet)
	/// @desc Applies clamps/snaps and optionally emits value_changed.
	/// @param {Real} _next_value
	/// @param {Bool} _quiet
	#endregion
	static __apply_value = function(_next_value, _quiet)
	{
		var _new_value = _next_value;
		
		//clamp value
		if not (allow_lesser || allow_greater) {
			var _new_value = clamp(
				_new_value,
				(allow_lesser) ? -infinity : min_value,
				(allow_greater) ? infinity : max_value
			);
		}
		
		//snap to step amount
		if (step > 0.0) {
			var _offset = _new_value - min_value;
			var _steps = round(_offset / step);
			_new_value = min_value + (_steps * step);
		}
		
		//round
		if (rounded) _new_value = floor(_new_value + 0.5);
		
		//return if unchanged
		if (value == _new_value) { return; }
		
		value = _new_value;
		
		__share_push_state();
		
		if (!_quiet) {
			__trigger_event(events.value_changed, value)
		}
		_value_changed(value);
	};

	#region jsDoc
	/// @func __clamp01(_val)
	/// @desc Clamps to [0..1].
	/// @param {Real} _val
	/// @return {Real}
	#endregion
	static __clamp01 = function(_val)
	{
		if (_val < 0.0) { return 0.0; }
		if (_val > 1.0) { return 1.0; }
		return _val;
	};

	#region jsDoc
	/// @func __range_span()
	/// @desc Returns max-min (never below 0).
	/// @return {Real}
	#endregion
	static __range_span = function()
	{
		var _span = max_value - min_value;
		if (_span < 0.0) { _span = 0.0; }
		return _span;
	};

	#region jsDoc
	/// @func __value_to_ratio(_val)
	/// @desc Maps value to ratio in [0..1] using current settings.
	/// @param {Real} _val
	/// @return {Real}
	#endregion
	static __value_to_ratio = function(_val)
	{
		var _span = __range_span();
		if (_span <= 0.0) { return 0.0; }

		var _norm = (_val - min_value) / _span;
		_norm = __clamp01(_norm);

		if (exp_edit && (min_value >= 0.0))
		{
			_norm = _norm * _norm;
		}

		return _norm;
	};

	#region jsDoc
	/// @func __ratio_to_value(_ratio)
	/// @desc Maps ratio to value using current settings.
	/// @param {Real} _ratio
	/// @return {Real}
	#endregion
	static __ratio_to_value = function(_ratio)
	{
		var _span = __range_span();
		if (_span <= 0.0) { return min_value; }

		var _norm = __clamp01(_ratio);

		if (exp_edit && (min_value >= 0.0))
		{
			_norm = sqrt(_norm);
		}

		return min_value + (_norm * _span);
	};

	#region jsDoc
	/// @func __share_merge_groups(_with)
	/// @desc Merges share groups for simple sync behavior.
	/// @param {Struct.__ReflexRange} _with
	#endregion
	static __share_merge_groups = function(_with)
	{
		var _lhs = __share_group;
		var _rhs = _with.__share_group;

		if ((_lhs == undefined) && (_rhs == undefined))
		{
			__share_group = [self, _with];
			_with.__share_group = __share_group;
			return;
		}

		if ((_lhs != undefined) && (_rhs == undefined))
		{
			array_push(_lhs, _with);
			_with.__share_group = _lhs;
			return;
		}

		if ((_lhs == undefined) && (_rhs != undefined))
		{
			array_push(_rhs, self);
			__share_group = _rhs;
			return;
		}

		if (_lhs == _rhs) { return; }
		
		var _count = array_length(_rhs);
		var _indx = 0;
		repeat (_count)
		{
			var _node = _rhs[_indx];
			array_push(_lhs, _node);
			_node.__share_group = _lhs;
			_indx += 1;
		}

		__share_group = _lhs;
		_with.__share_group = _lhs;
	};

	#region jsDoc
	/// @func __share_push_state()
	/// @desc Pushes this range state to its share group.
	#endregion
	static __share_push_state = function()
	{
		if (__share_group == undefined) { return; }

		var _count = array_length(__share_group);
		var _indx = 0;
		repeat (_count)
		{
			var _node = __share_group[_indx];
			if ((_node != undefined) && (_node != self))
			{
				_node.allow_greater = allow_greater;
				_node.allow_lesser = allow_lesser;
				_node.exp_edit = exp_edit;

				_node.min_value = min_value;
				_node.max_value = max_value;
				_node.page = page;

				_node.rounded = rounded;
				_node.step = step;

				_node.__apply_value(value, true);
			}
			_indx += 1;
		}
	};

	#endregion
	
	#endregion
}