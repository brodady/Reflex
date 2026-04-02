#region jsDoc
/// @func    ReflexUIObject()
/// @desc    ReflexUI wrapper around ReflexLeafObject.
///          This keeps ReflexLeafObject lightweight while exposing a ReflexUI-aware
///          object wrapper that can participate in ReflexUI input binding.
/// @returns {Struct.ReflexUIObject}
#endregion
function ReflexUIObject() : ReflexUI() constructor
{
	#region Setters
	
	#region jsDoc
	/// @func    set_anchor(_valign_or_preset, _halign)
	/// @desc    Forwards to the wrapped ReflexLeafObject anchor setter.
	/// @self    ReflexUIObject
	/// @param   {Constant.Valign|String} _valign_or_preset
	/// @param   {Constant.Halign|Undefined} _halign
	/// @returns {Struct.ReflexUIObject}
	#endregion
	static set_anchor = function(_valign_or_preset, _halign = undefined)
	{
		__leaf.set_anchor(_valign_or_preset, _halign);
		return self;
	};
	
	#region jsDoc
	/// @func    set_stretch(_width, _height)
	/// @desc    Forwards stretch flags to the wrapped ReflexLeafObject.
	/// @self    ReflexUIObject
	/// @param   {Bool} _width
	/// @param   {Bool} _height
	/// @returns {Struct.ReflexUIObject}
	#endregion
	static set_stretch = function(_width, _height)
	{
		__leaf.set_stretch(_width, _height);
		return self;
	};
	
	#region jsDoc
	/// @func    set_keep_aspect(_enabled)
	/// @desc    Forwards keep-aspect behavior to the wrapped ReflexLeafObject.
	/// @self    ReflexUIObject
	/// @param   {Bool} _enabled
	/// @returns {Struct.ReflexUIObject}
	#endregion
	static set_keep_aspect = function(_enabled)
	{
		__leaf.set_keep_aspect(_enabled);
		return self;
	};
	
	#region jsDoc
	/// @func    set_tiling(_horizontal, _vertical)
	/// @desc    Forwards tiling behavior to the wrapped ReflexLeafObject.
	/// @self    ReflexUIObject
	/// @param   {Bool} _horizontal
	/// @param   {Bool} _vertical
	/// @returns {Struct.ReflexUIObject}
	#endregion
	static set_tiling = function(_horizontal, _vertical)
	{
		__leaf.set_tiling(_horizontal, _vertical);
		return self;
	};
	
	#region jsDoc
	/// @func    set_visible(_enabled)
	/// @desc    Forwards visibility to the wrapped ReflexLeafObject.
	/// @self    ReflexUIObject
	/// @param   {Bool} _enabled
	/// @returns {Struct.ReflexUIObject}
	#endregion
	static set_visible = function(_enabled)
	{
		__leaf.set_visible(_enabled);
		return self;
	};
	
	#region jsDoc
	/// @func    set_instance_object(_object)
	/// @desc    Sets the wrapped instance object asset.
	/// @self    ReflexUIObject
	/// @param   {Asset.GMObject} _object
	/// @returns {Struct.ReflexUIObject}
	#endregion
	static set_instance_object = function(_object)
	{
		__leaf.set_instance_object(_object);
		return self;
	};
	
	#region jsDoc
	/// @func    set_instance_offsets(_x, _y)
	/// @desc    Sets the wrapped instance offsets.
	/// @self    ReflexUIObject
	/// @param   {Real} _x
	/// @param   {Real} _y
	/// @returns {Struct.ReflexUIObject}
	#endregion
	static set_instance_offsets = function(_x, _y)
	{
		__leaf.set_instance_offsets(_x, _y);
		return self;
	};
	
	#region jsDoc
	/// @func    set_instance_scale(_x, _y)
	/// @desc    Sets the wrapped instance scale.
	/// @self    ReflexUIObject
	/// @param   {Real} _x
	/// @param   {Real|Undefined} _y
	/// @returns {Struct.ReflexUIObject}
	#endregion
	static set_instance_scale = function(_x, _y = undefined)
	{
		__leaf.set_instance_scale(_x, _y);
		return self;
	};
	
	#region jsDoc
	/// @func    set_instance_image_speed(_speed)
	/// @desc    Sets the wrapped instance image_speed.
	/// @self    ReflexUIObject
	/// @param   {Real} _speed
	/// @returns {Struct.ReflexUIObject}
	#endregion
	static set_instance_image_speed = function(_speed)
	{
		__leaf.set_instance_image_speed(_speed);
		return self;
	};
	
	#region jsDoc
	/// @func    set_instance_image_index(_index)
	/// @desc    Sets the wrapped instance image_index.
	/// @self    ReflexUIObject
	/// @param   {Real} _index
	/// @returns {Struct.ReflexUIObject}
	#endregion
	static set_instance_image_index = function(_index)
	{
		__leaf.set_instance_image_index(_index);
		return self;
	};
	
	#region jsDoc
	/// @func    set_instance_color(_color)
	/// @desc    Sets the wrapped instance color.
	/// @self    ReflexUIObject
	/// @param   {Int} _color
	/// @returns {Struct.ReflexUIObject}
	#endregion
	static set_instance_color = function(_color)
	{
		__leaf.set_instance_color(_color);
		return self;
	};
	static set_instance_colour = set_instance_color;
	
	#region jsDoc
	/// @func    set_instance_angle(_angle)
	/// @desc    Sets the wrapped instance image_angle.
	/// @self    ReflexUIObject
	/// @param   {Real} _angle
	/// @returns {Struct.ReflexUIObject}
	#endregion
	static set_instance_angle = function(_angle)
	{
		__leaf.set_instance_angle(_angle);
		return self;
	};
	
	#region jsDoc
	/// @func    set_variable(_name, _value)
	/// @desc    Writes an instance variable definition to the wrapped ReflexLeafObject.
	///          If the runtime instance already exists, the live instance value is updated too.
	/// @self    ReflexUIObject
	/// @param   {String} _name
	/// @param   {Any} _value
	/// @returns {Struct.ReflexUIObject}
	#endregion
	static set_variable = function(_name, _value)
	{
		__leaf.set_variable(_name, _value);
		return self;
	};
	
	#endregion
	
	#region Getters
	
	#region jsDoc
	/// @func    get_type()
	/// @desc    Gets the wrapped leaf type string.
	/// @self    ReflexUIObject
	/// @returns {String}
	#endregion
	static get_type = function()
	{
		return __leaf.get_type();
	};
	
	#region jsDoc
	/// @func    get_element_id()
	/// @desc    Gets the wrapped element id.
	/// @self    ReflexUIObject
	/// @returns {Real}
	#endregion
	static get_element_id = function()
	{
		return __leaf.get_element_id();
	};
	
	#region jsDoc
	/// @func    get_element_order()
	/// @desc    Gets the wrapped element order.
	/// @self    ReflexUIObject
	/// @returns {Real}
	#endregion
	static get_element_order = function()
	{
		return __leaf.get_element_order();
	};
	
	#region jsDoc
	/// @func    get_anchor()
	/// @desc    Gets the wrapped anchor preset.
	/// @self    ReflexUIObject
	/// @returns {String}
	#endregion
	static get_anchor = function()
	{
		return __leaf.get_anchor();
	};
	
	#region jsDoc
	/// @func    get_stretch_width()
	/// @desc    Gets the wrapped stretch width flag.
	/// @self    ReflexUIObject
	/// @returns {Bool}
	#endregion
	static get_stretch_width = function()
	{
		return __leaf.get_stretch_width();
	};
	
	#region jsDoc
	/// @func    get_stretch_height()
	/// @desc    Gets the wrapped stretch height flag.
	/// @self    ReflexUIObject
	/// @returns {Bool}
	#endregion
	static get_stretch_height = function()
	{
		return __leaf.get_stretch_height();
	};
	
	#region jsDoc
	/// @func    get_keep_aspect()
	/// @desc    Gets the wrapped keep-aspect flag.
	/// @self    ReflexUIObject
	/// @returns {Bool}
	#endregion
	static get_keep_aspect = function()
	{
		return __leaf.get_keep_aspect();
	};
	
	#region jsDoc
	/// @func    get_tile_horizontal()
	/// @desc    Gets the wrapped horizontal tile flag.
	/// @self    ReflexUIObject
	/// @returns {Bool}
	#endregion
	static get_tile_horizontal = function()
	{
		return __leaf.get_tile_horizontal();
	};
	
	#region jsDoc
	/// @func    get_tile_vertical()
	/// @desc    Gets the wrapped vertical tile flag.
	/// @self    ReflexUIObject
	/// @returns {Bool}
	#endregion
	static get_tile_vertical = function()
	{
		return __leaf.get_tile_vertical();
	};
	
	#region jsDoc
	/// @func    get_instance_object()
	/// @desc    Gets the wrapped instance object asset.
	/// @self    ReflexUIObject
	/// @returns {Asset.GMObject}
	#endregion
	static get_instance_object = function()
	{
		return __leaf.get_instance_object();
	};
	
	#region jsDoc
	/// @func    get_instance_variables()
	/// @desc    Gets the wrapped instanceVariables struct.
	/// @self    ReflexUIObject
	/// @returns {Struct}
	#endregion
	static get_instance_variables = function()
	{
		return __leaf.get_instance_variables();
	};
	
	#region jsDoc
	/// @func    get_variable_definition(_name)
	/// @desc    Gets a wrapped instance variable definition value.
	/// @self    ReflexUIObject
	/// @param   {String} _name
	/// @returns {Any}
	#endregion
	static get_variable_definition = function(_name)
	{
		return variable_struct_get(__leaf.get_instance_variables(), _name);
	};
	
	#region jsDoc
	/// @func    get_instance_offsets_x()
	/// @desc    Gets the wrapped instance X offset.
	/// @self    ReflexUIObject
	/// @returns {Real}
	#endregion
	static get_instance_offsets_x = function()
	{
		return __leaf.get_instance_offsets_x();
	};
	
	#region jsDoc
	/// @func    get_instance_offsets_y()
	/// @desc    Gets the wrapped instance Y offset.
	/// @self    ReflexUIObject
	/// @returns {Real}
	#endregion
	static get_instance_offsets_y = function()
	{
		return __leaf.get_instance_offsets_y();
	};
	
	#region jsDoc
	/// @func    get_instance_scale_x()
	/// @desc    Gets the wrapped instance X scale.
	/// @self    ReflexUIObject
	/// @returns {Real}
	#endregion
	static get_instance_scale_x = function()
	{
		return __leaf.get_instance_scale_x();
	};
	
	#region jsDoc
	/// @func    get_instance_scale_y()
	/// @desc    Gets the wrapped instance Y scale.
	/// @self    ReflexUIObject
	/// @returns {Real}
	#endregion
	static get_instance_scale_y = function()
	{
		return __leaf.get_instance_scale_y();
	};
	
	#region jsDoc
	/// @func    get_instance_image_speed()
	/// @desc    Gets the wrapped instance image_speed.
	/// @self    ReflexUIObject
	/// @returns {Real}
	#endregion
	static get_instance_image_speed = function()
	{
		return __leaf.get_instance_image_speed();
	};
	
	#region jsDoc
	/// @func    get_instance_image_index()
	/// @desc    Gets the wrapped instance image_index.
	/// @self    ReflexUIObject
	/// @returns {Real}
	#endregion
	static get_instance_image_index = function()
	{
		return __leaf.get_instance_image_index();
	};
	
	#region jsDoc
	/// @func    get_instance_color()
	/// @desc    Gets the wrapped instance color.
	/// @self    ReflexUIObject
	/// @returns {Int}
	#endregion
	static get_instance_color = function()
	{
		return __leaf.get_instance_color();
	};
	static get_instance_colour = get_instance_color;
	
	#region jsDoc
	/// @func    get_instance_angle()
	/// @desc    Gets the wrapped instance image_angle.
	/// @self    ReflexUIObject
	/// @returns {Real}
	#endregion
	static get_instance_angle = function()
	{
		return __leaf.get_instance_angle();
	};
	
	#region jsDoc
	/// @func    get_instance_id()
	/// @desc    Gets the wrapped runtime instance id.
	/// @self    ReflexUIObject
	/// @returns {Id.Instance}
	#endregion
	static get_instance_id = function()
	{
		return __leaf.get_instance_id();
	};
	
	#endregion
	
	#region Functions
	
	#region jsDoc
	/// @func    get_leaf()
	/// @desc    Gets the wrapped ReflexLeafObject.
	/// @self    ReflexUIObject
	/// @returns {Struct.ReflexLeafObject}
	#endregion
	static get_leaf = function()
	{
		return __leaf;
	};
	
	#region jsDoc
	/// @func    call_on_element_ready(_function)
	/// @desc    Forwards the element-ready callback to the wrapped ReflexLeafObject.
	/// @self    ReflexUIObject
	/// @param   {Method|Function} _function
	/// @returns {Struct.ReflexUIObject}
	#endregion
	static call_on_element_ready = function(_function)
	{
		__leaf.call_on_element_ready(_function);
		return self;
	};
	
	#region jsDoc
	/// @func    call_on_instance_ready(_function)
	/// @desc    Forwards the instance-ready callback to the wrapped ReflexLeafObject.
	/// @self    ReflexUIObject
	/// @param   {Method|Function} _function
	/// @returns {Struct.ReflexUIObject}
	#endregion
	static call_on_instance_ready = function(_function)
	{
		__leaf.call_on_instance_ready(_function);
		return self;
	};
	
	#region jsDoc
	/// @func    to_struct()
	/// @desc    Gets the wrapped leaf layerElement struct.
	/// @self    ReflexUIObject
	/// @returns {Struct}
	#endregion
	static to_struct = function()
	{
		return __leaf.to_struct();
	};
	
	#region jsDoc
	/// @func    __input_get_wrapped_instance()
	/// @desc    ReflexUI input bridge for wrapped object instances.
	/// @self    ReflexUIObject
	/// @returns {Id.Instance}
	/// @ignore
	#endregion
	static __input_get_wrapped_instance = function()
	{
		return __leaf.get_instance_id();
	};
	
	#endregion
	
	#region Events
	
	#endregion
	
	#region Private
	
	__leaf = new ReflexLeafObject();
	add(__leaf);
	
	__leaf.call_on_instance_ready(function(_instance_id) {
		__input_bind_instance(_instance_id);
	});
	
	#endregion
}