#region jsDoc
/// @func    __reflex_input_manager_get()
/// @desc    Returns the global Reflex input manager, creating it if needed.
/// @returns {Struct}
/// @ignore
#endregion
function __reflex_input_manager_get()
{
	static __ = {
		frame_stamp: -1,
		order_index: 0,
		raw: {
			mouse_x: 0,
			mouse_y: 0,
			mouse_left_down: false,
			mouse_left_pressed: false,
			mouse_left_released: false
		},
		verbs_native: {},
		verbs_external: {},
		verbs_final: {},
		registrations: [],
		resolved_frame: -1,
		resolved: {
			hovered_id: undefined,
			pressed_id: undefined,
			released_id: undefined,
			clicked_id: undefined,
			active_id: undefined,
			captured_id: undefined,
			focused_id: undefined
		},
		pointer_consumed: false,
		action_consumed: {}
	};

	return __;
}

#region jsDoc
/// @func    __reflex_input_frame_begin()
/// @desc    Starts a new Reflex input frame if needed.
/// @returns {Struct}
/// @ignore
#endregion
function __reflex_input_frame_begin()
{
	var _manager = __reflex_input_manager_get();
	var _stamp = current_time;
	if (_manager.frame_stamp == _stamp) {
		return _manager;
	}

	_manager.frame_stamp = _stamp;
	_manager.order_index = 0;
	_manager.registrations = [];
	_manager.pointer_consumed = false;
	_manager.action_consumed = {};
	_manager.resolved_frame = -1;
	_manager.resolved.hovered_id = undefined;
	_manager.resolved.pressed_id = undefined;
	_manager.resolved.released_id = undefined;
	_manager.resolved.clicked_id = undefined;

	_manager.raw.mouse_x = device_mouse_x_to_gui(0);
	_manager.raw.mouse_y = device_mouse_y_to_gui(0);
	_manager.raw.mouse_left_down = mouse_check_button(mb_left);
	_manager.raw.mouse_left_pressed = mouse_check_button_pressed(mb_left);
	_manager.raw.mouse_left_released = mouse_check_button_released(mb_left);

	_manager.verbs_native = {};
	_manager.verbs_external = {};
	_manager.verbs_final = {};

	__reflex_input_build_native_verbs();
	__reflex_input_merge_verbs();

	return _manager;
}

#region jsDoc
/// @func    __reflex_input_build_native_verbs()
/// @desc    Builds the default Reflex verb table from built-in input.
/// @returns {Undefined}
/// @ignore
#endregion
function __reflex_input_build_native_verbs()
{
	__reflex_input_set_native_verb(
		"accept",
		keyboard_check(vk_enter) || keyboard_check(vk_space) || gamepad_button_check(0, gp_face1),
		keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space) || gamepad_button_check_pressed(0, gp_face1),
		keyboard_check_released(vk_enter) || keyboard_check_released(vk_space) || gamepad_button_check_released(0, gp_face1),
		1
	);

	__reflex_input_set_native_verb(
		"cancel",
		keyboard_check(vk_escape) || gamepad_button_check(0, gp_face2),
		keyboard_check_pressed(vk_escape) || gamepad_button_check_pressed(0, gp_face2),
		keyboard_check_released(vk_escape) || gamepad_button_check_released(0, gp_face2),
		1
	);

	__reflex_input_set_native_verb(
		"left",
		keyboard_check(vk_left) || gamepad_button_check(0, gp_padl),
		keyboard_check_pressed(vk_left) || gamepad_button_check_pressed(0, gp_padl),
		keyboard_check_released(vk_left) || gamepad_button_check_released(0, gp_padl),
		-1
	);

	__reflex_input_set_native_verb(
		"right",
		keyboard_check(vk_right) || gamepad_button_check(0, gp_padr),
		keyboard_check_pressed(vk_right) || gamepad_button_check_pressed(0, gp_padr),
		keyboard_check_released(vk_right) || gamepad_button_check_released(0, gp_padr),
		1
	);

	__reflex_input_set_native_verb(
		"up",
		keyboard_check(vk_up) || gamepad_button_check(0, gp_padu),
		keyboard_check_pressed(vk_up) || gamepad_button_check_pressed(0, gp_padu),
		keyboard_check_released(vk_up) || gamepad_button_check_released(0, gp_padu),
		-1
	);

	__reflex_input_set_native_verb(
		"down",
		keyboard_check(vk_down) || gamepad_button_check(0, gp_padd),
		keyboard_check_pressed(vk_down) || gamepad_button_check_pressed(0, gp_padd),
		keyboard_check_released(vk_down) || gamepad_button_check_released(0, gp_padd),
		1
	);

	__reflex_input_set_native_verb(
		"focus_next",
		keyboard_check(vk_tab),
		keyboard_check_pressed(vk_tab),
		keyboard_check_released(vk_tab),
		1
	);

	__reflex_input_set_native_verb(
		"focus_prev",
		keyboard_check(vk_shift) && keyboard_check(vk_tab),
		keyboard_check(vk_shift) && keyboard_check_pressed(vk_tab),
		keyboard_check(vk_shift) && keyboard_check_released(vk_tab),
		-1
	);

	__reflex_input_set_native_verb(
		"pointer_accept",
		mouse_check_button(mb_left),
		mouse_check_button_pressed(mb_left),
		mouse_check_button_released(mb_left),
		1
	);
}

#region jsDoc
/// @func    __reflex_input_set_native_verb()
/// @desc    Writes a native verb entry.
/// @param   {String} _verb_name
/// @param   {Bool} _down_value
/// @param   {Bool} _pressed_value
/// @param   {Bool} _released_value
/// @param   {Real} _axis_value
/// @returns {Undefined}
/// @ignore
#endregion
function __reflex_input_set_native_verb(_verb_name, _down_value, _pressed_value, _released_value, _axis_value)
{
	var _manager = __reflex_input_manager_get();
	var _entry = {
		down: _down_value,
		pressed: _pressed_value,
		released: _released_value,
		value: _axis_value,
		source: "native"
	};

	variable_struct_set(_manager.verbs_native, _verb_name, _entry);
}

#region jsDoc
/// @func    __reflex_input_normalize_verb_value()
/// @desc    Normalizes external verb input into the internal verb struct shape.
/// @param   {Any} _verb_value
/// @returns {Struct}
/// @ignore
#endregion
function __reflex_input_normalize_verb_value(_verb_value)
{
	var _entry = {
		down: false,
		pressed: false,
		released: false,
		value: 0,
		source: "external"
	};

	if (is_bool(_verb_value) || is_real(_verb_value))
	{
		_entry.down = _verb_value;
		_entry.value = _verb_value;
		return _entry;
	}

	if (is_struct(_verb_value))
	{
		if (variable_struct_exists(_verb_value, "down")) {
			_entry.down = variable_struct_get(_verb_value, "down");
		}
		if (variable_struct_exists(_verb_value, "pressed")) {
			_entry.pressed = variable_struct_get(_verb_value, "pressed");
		}
		if (variable_struct_exists(_verb_value, "released")) {
			_entry.released = variable_struct_get(_verb_value, "released");
		}
		if (variable_struct_exists(_verb_value, "value")) {
			_entry.value = variable_struct_get(_verb_value, "value");
		}
		if (variable_struct_exists(_verb_value, "source")) {
			_entry.source = variable_struct_get(_verb_value, "source");
		}
	}

	return _entry;
}

#region jsDoc
/// @func    __reflex_input_merge_verbs()
/// @desc    Builds the final verb table. External verbs override native verbs
///          by matching name.
/// @returns {Struct}
/// @ignore
#endregion
function __reflex_input_merge_verbs()
{
	var _manager = __reflex_input_manager_get();
	_manager.verbs_final = {};

	var _verb_names = variable_struct_get_names(_manager.verbs_native);
	var _verb_count = array_length(_verb_names);
	for (var i = 0; i < _verb_count; i++)
	{
		var _verb_name = _verb_names[i];
		var _verb_data = variable_struct_get(_manager.verbs_native, _verb_name);
		variable_struct_set(_manager.verbs_final, _verb_name, _verb_data);
	}

	_verb_names = variable_struct_get_names(_manager.verbs_external);
	_verb_count = array_length(_verb_names);
	for (var j = 0; j < _verb_count; j++)
	{
		var _verb_name = _verb_names[j];
		var _verb_data = variable_struct_get(_manager.verbs_external, _verb_name);
		variable_struct_set(_manager.verbs_final, _verb_name, _verb_data);
	}

	return _manager.verbs_final;
}

#region jsDoc
/// @func    __reflex_input_resolve()
/// @desc    Resolves hovered, pressed, released, clicked, active, captured,
///          and focused ids for the current frame.
/// @returns {Struct}
/// @ignore
#endregion
function __reflex_input_resolve()
{
	__reflex_input_frame_begin();

	var _manager = __reflex_input_manager_get();
	if (_manager.resolved_frame == _manager.frame_stamp) {
		return _manager.resolved;
	}

	var _entries = _manager.registrations;
	array_sort(_entries, function(_left_entry, _right_entry) {
		return _right_entry.priority - _left_entry.priority;
	});

	var _mouse_x = _manager.raw.mouse_x;
	var _mouse_y = _manager.raw.mouse_y;
	var _hovered_id = undefined;

	var _entry_count = array_length(_entries);
	for (var i = 0; i < _entry_count; i++)
	{
		var _entry = _entries[i];
		if (point_in_rectangle(_mouse_x, _mouse_y, _entry.left, _entry.top, _entry.right, _entry.bottom))
		{
			_hovered_id = _entry.instance_id;
			break;
		}
	}

	_manager.resolved.hovered_id = _hovered_id;
	_manager.resolved.pressed_id = undefined;
	_manager.resolved.released_id = undefined;
	_manager.resolved.clicked_id = undefined;

	if (_manager.raw.mouse_left_pressed)
	{
		_manager.resolved.pressed_id = _hovered_id;
		_manager.resolved.active_id = _hovered_id;
		_manager.resolved.captured_id = _hovered_id;
		_manager.resolved.focused_id = _hovered_id;
	}

	if (_manager.raw.mouse_left_released)
	{
		_manager.resolved.released_id = _manager.resolved.captured_id;
		if (_manager.resolved.active_id != undefined && _manager.resolved.active_id == _hovered_id) {
			_manager.resolved.clicked_id = _manager.resolved.active_id;
		}
		_manager.resolved.active_id = undefined;
		_manager.resolved.captured_id = undefined;
	}

	_manager.resolved_frame = _manager.frame_stamp;
	return _manager.resolved;
}

#region jsDoc
/// @func    input_hovered()
/// @desc    Returns whether the instance is the current hovered target.
/// @param   {Id.Instance} _instance_id
/// @returns {Bool}
#endregion
function input_hovered(_instance_id)
{
	var _resolved = __reflex_input_resolve();
	return _resolved.hovered_id == _instance_id;
}

#region jsDoc
/// @func    input_pressed()
/// @desc    Returns whether the instance received pointer press this frame.
/// @param   {Id.Instance} _instance_id
/// @returns {Bool}
#endregion
function input_pressed(_instance_id)
{
	var _resolved = __reflex_input_resolve();
	return _resolved.pressed_id == _instance_id;
}

#region jsDoc
/// @func    input_released()
/// @desc    Returns whether the instance received pointer release this frame.
/// @param   {Id.Instance} _instance_id
/// @returns {Bool}
#endregion
function input_released(_instance_id)
{
	var _resolved = __reflex_input_resolve();
	return _resolved.released_id == _instance_id;
}

#region jsDoc
/// @func    input_clicked()
/// @desc    Returns whether the instance was clicked this frame.
/// @param   {Id.Instance} _instance_id
/// @returns {Bool}
#endregion
function input_clicked(_instance_id)
{
	var _resolved = __reflex_input_resolve();
	return _resolved.clicked_id == _instance_id;
}

#region jsDoc
/// @func    input_active()
/// @desc    Returns whether the instance is the current active target.
/// @param   {Id.Instance} _instance_id
/// @returns {Bool}
#endregion
function input_active(_instance_id)
{
	var _resolved = __reflex_input_resolve();
	return _resolved.active_id == _instance_id;
}

#region jsDoc
/// @func    input_captured()
/// @desc    Returns whether the instance currently owns pointer capture.
/// @param   {Id.Instance} _instance_id
/// @returns {Bool}
#endregion
function input_captured(_instance_id)
{
	var _resolved = __reflex_input_resolve();
	return _resolved.captured_id == _instance_id;
}

#region jsDoc
/// @func    input_focused()
/// @desc    Returns whether the instance currently owns focus.
/// @param   {Id.Instance} _instance_id
/// @returns {Bool}
#endregion
function input_focused(_instance_id)
{
	var _resolved = __reflex_input_resolve();
	return _resolved.focused_id == _instance_id;
}

#region jsDoc
/// @func    input_pointer_consumed()
/// @desc    Returns whether pointer input has been consumed this frame.
/// @returns {Bool}
#endregion
function input_pointer_consumed()
{
	var _manager = __reflex_input_manager_get();
	return _manager.pointer_consumed;
}

#region jsDoc
/// @func    input_consume_pointer()
/// @desc    Marks pointer input as consumed for the current frame.
/// @returns {Undefined}
#endregion
function input_consume_pointer()
{
	var _manager = __reflex_input_manager_get();
	_manager.pointer_consumed = true;
}

#region jsDoc
/// @func    input_action_down()
/// @desc    Returns whether the verb is currently down.
/// @param   {String} _verb_name
/// @returns {Bool}
#endregion
function input_action_down(_verb_name)
{
	__reflex_input_frame_begin();

	var _manager = __reflex_input_manager_get();
	if (!variable_struct_exists(_manager.verbs_final, _verb_name)) {
		return false;
	}

	var _verb_data = variable_struct_get(_manager.verbs_final, _verb_name);
	return _verb_data.down;
}

#region jsDoc
/// @func    input_action_pressed()
/// @desc    Returns whether the verb was pressed this frame.
/// @param   {String} _verb_name
/// @returns {Bool}
#endregion
function input_action_pressed(_verb_name)
{
	__reflex_input_frame_begin();

	if (input_action_consumed(_verb_name)) {
		return false;
	}

	var _manager = __reflex_input_manager_get();
	if (!variable_struct_exists(_manager.verbs_final, _verb_name)) {
		return false;
	}

	var _verb_data = variable_struct_get(_manager.verbs_final, _verb_name);
	return _verb_data.pressed;
}

#region jsDoc
/// @func    input_action_released()
/// @desc    Returns whether the verb was released this frame.
/// @param   {String} _verb_name
/// @returns {Bool}
#endregion
function input_action_released(_verb_name)
{
	__reflex_input_frame_begin();

	if (input_action_consumed(_verb_name)) {
		return false;
	}

	var _manager = __reflex_input_manager_get();
	if (!variable_struct_exists(_manager.verbs_final, _verb_name)) {
		return false;
	}

	var _verb_data = variable_struct_get(_manager.verbs_final, _verb_name);
	return _verb_data.released;
}

#region jsDoc
/// @func    input_action_value()
/// @desc    Returns the value associated with the verb.
/// @param   {String} _verb_name
/// @returns {Real}
#endregion
function input_action_value(_verb_name)
{
	__reflex_input_frame_begin();

	var _manager = __reflex_input_manager_get();
	if (!variable_struct_exists(_manager.verbs_final, _verb_name)) {
		return 0;
	}

	var _verb_data = variable_struct_get(_manager.verbs_final, _verb_name);
	return _verb_data.value;
}

#region jsDoc
/// @func    input_action_consume()
/// @desc    Marks a semantic action as consumed for the current frame.
/// @param   {String} _verb_name
/// @returns {Undefined}
#endregion
function input_action_consume(_verb_name)
{
	var _manager = __reflex_input_manager_get();
	variable_struct_set(_manager.action_consumed, _verb_name, true);
}

#region jsDoc
/// @func    input_action_consumed()
/// @desc    Returns whether a semantic action has already been consumed.
/// @param   {String} _verb_name
/// @returns {Bool}
#endregion
function input_action_consumed(_verb_name)
{
	var _manager = __reflex_input_manager_get();
	if (!variable_struct_exists(_manager.action_consumed, _verb_name)) {
		return false;
	}

	return variable_struct_get(_manager.action_consumed, _verb_name);
}
