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
		call_when_instance_exists(function(_inst) {
			_inst.step = __step;
		})
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
		call_when_instance_exists(function(_inst) {
			_inst.draw = __draw;
		})
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
	
	#endregion
}