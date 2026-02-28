#region jsDoc
/// @desc
///		ReflexCenterContainer centers its children within the container.
///		Inspired by Godot's CenterContainer, but not a 1:1 replica.
///
///		By default, children are centered on both axes.
///		If use_top_left is enabled, children are aligned to the top-left instead.
///
///		This container does not require special reflow logic; it is purely flex presets.
///
#endregion
function ReflexCenterContainer(_data=undefined) : ReflexContainer(_data) constructor
{
	
	#region jsDoc
	/// @func    set_use_top_left()
	/// @desc    If true, aligns children to the top-left instead of centering.
	/// @self    ReflexCenterContainer
	/// @param   {Bool} _value : If true, use top-left alignment.
	/// @returns {Struct.ReflexCenterContainer}
	#endregion
	static set_use_top_left = function(_value)
	{
		__use_top_left = _value;

		if (__use_top_left) {
			set_align_items(flexpanel_align.flex_start);
			set_justify_content(flexpanel_justify.start);
		}
		else {
			set_align_items(flexpanel_align.center);
			set_justify_content(flexpanel_justify.center);
		}

		request_reflow();
		return self;
	};

	#region jsDoc
	/// @func    is_using_top_left()
	/// @desc    Returns whether top-left alignment is enabled.
	/// @self    ReflexCenterContainer
	/// @returns {Bool}
	#endregion
	static is_using_top_left = function()
	{
		return __use_top_left;
	};
	
	#region Private
	
	__use_top_left = false;
	
	// Defaults
	set_display(flexpanel_display.flex);
	set_flex_wrap(flexpanel_wrap.no_wrap);
	
	// Centering behavior
	set_align_items(flexpanel_align.center);
	set_justify_content(flexpanel_justify.center);
	
	#endregion
}