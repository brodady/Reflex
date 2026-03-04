#region jsDoc
/// @func ReflexHScrollBar()
/// @desc Horizontal scrollbar component (left min, right max).
///       Public wrapper around __ReflexScrollBar.
/// @return {Struct.ReflexHScrollBar}
#endregion
function ReflexHScrollBar() : __ReflexScrollBar() constructor
{
	#region Setters

	#region jsDoc
	/// @func set_padding_top(_value)
	/// @desc Sets vertical padding above the grabber within the track.
	/// @param {Real} _value
	/// @return {Struct.ReflexHScrollBar}
	#endregion
	static set_padding_top = function(_value)
	{
		__track_pad_a = _value;
		return self;
	};

	#region jsDoc
	/// @func set_padding_bottom(_value)
	/// @desc Sets vertical padding below the grabber within the track.
	/// @param {Real} _value
	/// @return {Struct.ReflexHScrollBar}
	#endregion
	static set_padding_bottom = function(_value)
	{
		__track_pad_b = _value;
		return self;
	};

	#endregion

	#region Getters

	#region jsDoc
	/// @func get_padding_top()
	/// @desc Returns top padding.
	/// @return {Real}
	#endregion
	static get_padding_top = function() { return __track_pad_a; };

	#region jsDoc
	/// @func get_padding_bottom()
	/// @desc Returns bottom padding.
	/// @return {Real}
	#endregion
	static get_padding_bottom = function() { return __track_pad_b; };

	#endregion

	#region Private

	__axis = 0;
	__track_pad_a = 0.0;
	__track_pad_b = 0.0;

	#endregion
}