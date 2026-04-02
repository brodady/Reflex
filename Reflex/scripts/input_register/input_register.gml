#region jsDoc
/// @func    input_register()
/// @desc    Registers an instance as an input candidate for the current frame.
///          This implicitly calls input_begin().
/// @param   {Id.Instance} _instance_id
/// @returns {Bool}
#endregion
function input_register(_instance_id)
{
	if (!instance_exists(_instance_id)) {
		return false;
	}

	var _cache = input_begin(_instance_id);
	if (_cache == undefined) {
		return false;
	}

	if (!_instance_id.visible) {
		return false;
	}

	if (_cache.blocked) {
		return false;
	}

	if (!_cache.clip_valid) {
		return false;
	}

	if (!_cache.hit_valid) {
		return false;
	}

	var _manager = __reflex_input_manager_get();
	var _entry = {
		instance_id: _instance_id,
		left: _cache.hit_left,
		top: _cache.hit_top,
		right: _cache.hit_right,
		bottom: _cache.hit_bottom,
		priority: _cache.priority,
		popup: _cache.popup,
		modal: _cache.modal
	};

	array_push(_manager.registrations, _entry);
	return true;
}
