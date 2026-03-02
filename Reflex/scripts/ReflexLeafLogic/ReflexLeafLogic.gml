#region jsDoc
/// @func ReflexLeafLogic(_helper_object)
/// @desc Instance leaf that injects Step/Draw behavior into obj_reflex_logic_handler.
///       Stores callbacks in __step/__draw so they can be re-applied after rebuilds.
/// @param {Asset.GMObject} [_helper_object]=obj_reflex_logic_handler
#endregion
function ReflexLeafLogic(_helper_object=obj_reflex_logic_handler) : ReflexLeafObject(_helper_object) constructor
{
	#region jsDoc
	/// @func    set_step()
	/// @desc    Sets the stored step callback and applies it to the helper instance if available.
	/// @self    ReflexLeafLogic
	/// @param   {Method|Undefined} _method
	/// @returns {Struct.ReflexLeafLogic}
	#endregion
	static set_step = function(_method)
	{
		__step = _method;
		__sync_helper();
		return self;
	};

	#region jsDoc
	/// @func    set_draw()
	/// @desc    Sets the stored draw callback and applies it to the helper instance if available.
	/// @self    ReflexLeafLogic
	/// @param   {Method|Undefined} _method
	/// @returns {Struct.ReflexLeafLogic}
	#endregion
	static set_draw = function(_method)
	{
		__draw = _method;
		__sync_helper();
		return self;
	};

	#region jsDoc
	/// @func    get_step()
	/// @desc    Returns the stored step callback.
	/// @self    ReflexLeafLogic
	/// @returns {Method|Undefined}
	#endregion
	static get_step = function()
	{
		return __step;
	};

	#region jsDoc
	/// @func    get_draw()
	/// @desc    Returns the stored draw callback.
	/// @self    ReflexLeafLogic
	/// @returns {Method|Undefined}
	#endregion
	static get_draw = function()
	{
		return __draw;
	};
	
	#region Private
	__step = undefined;
	__draw = undefined;
	
	#region jsDoc
	/// @func    __sync_helper()
	/// @desc    Re-applies stored __step/__draw to the current helper instance (if it exists).
	///          Call this after any rebuild that may recreate the instance.
	/// @self    ReflexLeafLogic
	/// @returns {Bool}
	/// @ignore
	#endregion
	static __sync_helper = function()
	{
		var _inst = get_instance_id();
		if (_inst == undefined) { return false; }
		if (!instance_exists(_inst)) { return false; }
		
		if (_inst == -1) {
			call_later(1, time_source_units_frames, method(self, __sync_helper), false)
			return false;
		}
		
		_inst.step = __step;
		_inst.draw = __draw;
		
		return true;
	};

	#endregion
}