#region jsDoc
/// @desc
///		Instance layer element descriptor.
///		Produces a struct compatible with a layerElements entry of type "Instance".
///
#endregion
function ReflexLayerElementInstance() : ReflexLayerElementBase() constructor
{
	set_common("Instance", 0.0, 0.0);
	
	instanceObjectIndex = undefined;
	instanceVariables = {};
	instanceOffsetX = 0.0;
	instanceOffsetY = 0.0;
	
	instanceScaleX = 1.0;
	instanceScaleY = 1.0;
	
	instanceImageSpeed = 1.0;
	instanceImageIndex = 0.0;
	
	instanceColour = -1.0;
	instanceAngle = 0.0;
	
	instanceId = noone;
	
	#region jsDoc
	/// @func    set_object()
	/// @desc    Sets the object.
	/// @self    ReflexLayerElementInstance
	/// @param   {String} _object_ref
	/// @returns {Struct.ReflexLayerElementInstance}
	#endregion
	static set_object = function(_obj)
	{
		instanceObjectIndex = _obj;
		return self;
	};

	#region jsDoc
	/// @func    set_instance_ref()
	/// @desc    Sets the instance reference string (ex: "@ref instance(100000)").
	/// @self    ReflexLayerElementInstance
	/// @param   {String} _instance_ref
	/// @returns {Struct.ReflexLayerElementInstance}
	#endregion
	static set_instance_ref = function(_instance_ref)
	{
		instanceId = is_string(_instance_ref) ? _instance_ref : instanceId;
		return self;
	};

	#region jsDoc
	/// @func    set_variables()
	/// @desc    Sets the instanceVariables struct (copied by reference).
	/// @self    ReflexLayerElementInstance
	/// @param   {Struct} _vars_struct
	/// @returns {Struct.ReflexLayerElementInstance}
	#endregion
	static set_variables = function(_vars_struct)
	{
		if (is_struct(_vars_struct))
		{
			instanceVariables = _vars_struct;
		}
		return self;
	};

	#region jsDoc
	/// @func    set_transform()
	/// @desc    Sets transform related fields for the instance element.
	/// @self    ReflexLayerElementInstance
	/// @param   {Real} _offset_x
	/// @param   {Real} _offset_y
	/// @param   {Real} _scale_x
	/// @param   {Real} _scale_y
	/// @param   {Real} _angle
	/// @returns {Struct.ReflexLayerElementInstance}
	#endregion
	static set_transform = function(_offset_x, _offset_y, _scale_x=1.0, _scale_y=1.0, _angle=0.0)
	{
		instanceOffsetX = _offset_x;
		instanceOffsetY = _offset_y;
		instanceScaleX = _scale_x;
		instanceScaleY = _scale_y;
		instanceAngle = _angle;
		return self;
	};

	#region jsDoc
	/// @func    set_image()
	/// @desc    Sets image index and speed for the instance element.
	/// @self    ReflexLayerElementInstance
	/// @param   {Real} _image_index
	/// @param   {Real} _image_speed
	/// @returns {Struct.ReflexLayerElementInstance}
	#endregion
	static set_image = function(_image_index, _image_speed=1.0)
	{
		instanceImageIndex = _image_index;
		instanceImageSpeed = _image_speed;
		return self;
	};

	#region jsDoc
	/// @func    to_struct()
	/// @desc    Builds an "Instance" layerElements struct.
	/// @self    ReflexLayerElementInstance
	/// @returns {Struct}
	#endregion
	static to_struct = function()
	{
		static __base_to_struct = ReflexLayerElementBase.to_struct;
		var _base_struct = __base_to_struct();
		
		_base_struct.instanceObjectIndex = instanceObjectIndex;
		_base_struct.instanceVariables = instanceVariables;

		_base_struct.instanceOffsetX = instanceOffsetX;
		_base_struct.instanceOffsetY = instanceOffsetY;

		_base_struct.instanceScaleX = instanceScaleX;
		_base_struct.instanceScaleY = instanceScaleY;

		_base_struct.instanceImageSpeed = instanceImageSpeed;
		_base_struct.instanceImageIndex = instanceImageIndex;

		_base_struct.instanceColour = instanceColour;
		_base_struct.instanceAngle = instanceAngle;

		_base_struct.instanceId = instanceId;
		
		_base_struct.flexTileHorizontal = false;
		_base_struct.flexTileVertical =  false;
		
		return _base_struct;
	};
}
