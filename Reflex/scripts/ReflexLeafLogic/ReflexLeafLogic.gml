#region jsDoc
/// @func ReflexLeafLogic(_helper_object)
/// @desc Instance leaf that injects Step/Draw behavior into __obj_reflex_logic_handler.
///       Stores callbacks in __step/__draw so they can be re-applied after rebuilds.
/// @param {Asset.GMObject} [_helper_object]=__obj_reflex_logic_handler
#endregion
function ReflexLeafLogic() : ReflexLeafObject() constructor
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
		set_variable("step", _method)
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
		set_variable("draw", _method)
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
    /// @func rebuild_node(_element_struct)
    /// @desc Recreates the native Flexpanel node to apply layerElement changes.
    /// @param {Struct} _element_struct The layerElements struct defining the type (Sprite/Text).
    #endregion
    static rebuild_node = function(_element_struct=to_struct()) {
		static __base_rebuild_node = ReflexLeafObject.rebuild_node;
		__base_rebuild_node(_element_struct);
	}
	
	#endregion
	
	set_instance_object(__obj_reflex_logic_handler);
}