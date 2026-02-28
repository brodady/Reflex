#region jsDoc
/// @desc
///		ReflexPaddingContainer applies container-wide padding (inner inset) to its contents.
///		This affects the interior content area for all children (not per-child padding).
///		Pure flex preset - no special reflow logic.
///
/// @self ReflexPaddingContainer
#endregion
function ReflexPaddingContainer(_data=undefined) : ReflexContainer(_data) constructor
{
	#region jsDoc
	/// @func    set_padding_all()
	/// @desc    Sets all 4 paddings (left/top/right/bottom) to the same pixel value.
	/// @self    ReflexPaddingContainer
	/// @param   {Real} _pixels : Padding size in pixels.
	/// @returns {Struct.ReflexPaddingContainer}
	#endregion
	static set_padding_all = function(_pixels)
	{
		var _val = max(0, _pixels);

		__padding_left = _val;
		__padding_top = _val;
		__padding_right = _val;
		__padding_bottom = _val;

		__apply_padding();
		return self;
	};

	#region jsDoc
	/// @func    set_paddings()
	/// @desc    Sets padding for each side (pixels).
	/// @self    ReflexPaddingContainer
	/// @param   {Real} _left : Left padding in pixels.
	/// @param   {Real} _top : Top padding in pixels.
	/// @param   {Real} _right : Right padding in pixels.
	/// @param   {Real} _bottom : Bottom padding in pixels.
	/// @returns {Struct.ReflexPaddingContainer}
	#endregion
	static set_paddings = function(_left, _top, _right, _bottom)
	{
		__padding_left = max(0, _left);
		__padding_top = max(0, _top);
		__padding_right = max(0, _right);
		__padding_bottom = max(0, _bottom);

		__apply_padding();
		return self;
	};

	#region jsDoc
	/// @func    get_paddings()
	/// @desc    Returns the current padding values as a struct.
	/// @self    ReflexPaddingContainer
	/// @returns {Struct}
	#endregion
	static get_paddings = function()
	{
		return {
			left: __padding_left,
			top: __padding_top,
			right: __padding_right,
			bottom: __padding_bottom
		};
	};

	// -------------------------------------------------------------------------
	// Private
	// -------------------------------------------------------------------------
	#region Private

	__padding_left = 0;
	__padding_top = 0;
	__padding_right = 0;
	__padding_bottom = 0;

	set_display(flexpanel_display.flex);

	static __apply_padding = function()
	{
		set_padding(flexpanel_edge.left, __padding_left, flexpanel_unit.point);
		set_padding(flexpanel_edge.top, __padding_top, flexpanel_unit.point);
		set_padding(flexpanel_edge.right, __padding_right, flexpanel_unit.point);
		set_padding(flexpanel_edge.bottom, __padding_bottom, flexpanel_unit.point);

		request_reflow();
	};

	__apply_padding();

	#endregion
}