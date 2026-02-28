#region jsDoc
/// @desc
///		ReflexMarginContainer applies flexpanel margins (outer spacing) to this container.
///		This affects how this container is positioned relative to its parent and siblings.
///		Pure flex preset - no special reflow logic.
///
/// @self ReflexMarginContainer
#endregion
function ReflexMarginContainer(_data=undefined) : ReflexContainer(_data) constructor
{
	#region jsDoc
	/// @func    set_margin_all()
	/// @desc    Sets all 4 margins (left/top/right/bottom) to the same pixel value.
	/// @self    ReflexMarginContainer
	/// @param   {Real} _pixels : Margin size in pixels.
	/// @returns {Struct.ReflexMarginContainer}
	#endregion
	static set_margin_all = function(_pixels)
	{
		var _val = max(0, _pixels);

		__margin_left = _val;
		__margin_top = _val;
		__margin_right = _val;
		__margin_bottom = _val;

		__apply_margin();
		return self;
	};

	#region jsDoc
	/// @func    set_margins()
	/// @desc    Sets margin for each side (pixels). These are flexpanel margins on this container.
	/// @self    ReflexMarginContainer
	/// @param   {Real} _left : Left margin in pixels.
	/// @param   {Real} _top : Top margin in pixels.
	/// @param   {Real} _right : Right margin in pixels.
	/// @param   {Real} _bottom : Bottom margin in pixels.
	/// @returns {Struct.ReflexMarginContainer}
	#endregion
	static set_margins = function(_left, _top, _right, _bottom)
	{
		__margin_left = max(0, _left);
		__margin_top = max(0, _top);
		__margin_right = max(0, _right);
		__margin_bottom = max(0, _bottom);

		__apply_margin();
		return self;
	};

	#region jsDoc
	/// @func    get_margins()
	/// @desc    Returns the current margin values as a struct.
	/// @self    ReflexMarginContainer
	/// @returns {Struct}
	#endregion
	static get_margins = function()
	{
		return {
			left: __margin_left,
			top: __margin_top,
			right: __margin_right,
			bottom: __margin_bottom
		};
	};

	// -------------------------------------------------------------------------
	// Private
	// -------------------------------------------------------------------------
	#region Private

	__margin_left = 0;
	__margin_top = 0;
	__margin_right = 0;
	__margin_bottom = 0;

	set_display(flexpanel_display.flex);

	static __apply_margin = function()
	{
		set_margin(flexpanel_edge.left, __margin_left, flexpanel_unit.point);
		set_margin(flexpanel_edge.top, __margin_top, flexpanel_unit.point);
		set_margin(flexpanel_edge.right, __margin_right, flexpanel_unit.point);
		set_margin(flexpanel_edge.bottom, __margin_bottom, flexpanel_unit.point);

		request_reflow();
	};

	__apply_margin();

	#endregion
}