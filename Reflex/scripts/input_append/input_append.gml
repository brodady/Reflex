#region jsDoc
/// @func    input_append()
/// @desc    Appends external verb state for the current frame.
///          External verb state overrides native Reflex verb state when the
///          same verb name is supplied.
/// @param   {Struct} _verb_state
/// @returns {Struct}
#endregion
function input_append(_verb_state)
{
	var _manager = __reflex_input_manager_get();
	__reflex_input_frame_begin();

	if (_verb_state == undefined) {
		return _manager;
	}

	var _verb_names = variable_struct_get_names(_verb_state);
	var _verb_count = array_length(_verb_names);
	for (var i = 0; i < _verb_count; i++)
	{
		var _verb_name = _verb_names[i];
		var _verb_value = variable_struct_get(_verb_state, _verb_name);
		var _verb_data = __reflex_input_normalize_verb_value(_verb_value);
		variable_struct_set(_manager.verbs_external, _verb_name, _verb_data);
	}

	__reflex_input_merge_verbs();
	return _manager;
}
