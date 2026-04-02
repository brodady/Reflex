#region jsDoc
/// @func    input_begin()
/// @desc    Builds and caches __reflex_input for the instance for the current
///          frame. If the instance is bound to a Reflex node, the root node
///          input propagation pass is executed first.
/// @param   {Id.Instance} _instance_id
/// @returns {Struct}
#endregion
function input_begin(_instance_id)
{
	__reflex_input_frame_begin();

	if (!instance_exists(_instance_id)) {
		return undefined;
	}

	var _manager = __reflex_input_manager_get();
	var _cache = _instance_id.__reflex_input;
	if (_cache.frame == _manager.frame_stamp) {
		return _cache;
	}

	var _node = _instance_id.__reflex_node;
	if (_node != undefined)
	{
		var _root = _node.get_root();
		if (_root != undefined) {
			_root.__input_frame_begin();
		}
	}

	if (_cache.frame == _manager.frame_stamp) {
		return _cache;
	}

	_cache.frame = _manager.frame_stamp;
	_cache.clip_left = 0;
	_cache.clip_top = 0;
	_cache.clip_right = display_get_gui_width();
	_cache.clip_bottom = display_get_gui_height();
	_cache.clip_valid = _instance_id.visible;
	_cache.blocked = false;
	_cache.priority = 0;
	_cache.popup = false;
	_cache.modal = false;
	_cache.keep_pressed_outside = false;
	_cache.hit_left = max(_instance_id.bbox_left, _cache.clip_left);
	_cache.hit_top = max(_instance_id.bbox_top, _cache.clip_top);
	_cache.hit_right = min(_instance_id.bbox_right, _cache.clip_right);
	_cache.hit_bottom = min(_instance_id.bbox_bottom, _cache.clip_bottom);
	_cache.hit_valid =
		_cache.clip_valid &&
		(!_cache.blocked) &&
		(_cache.hit_left < _cache.hit_right) &&
		(_cache.hit_top < _cache.hit_bottom);

	return _cache;
}
