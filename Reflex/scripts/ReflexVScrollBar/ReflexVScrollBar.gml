#region jsDoc
/// @func ReflexVScrollBar()
/// @desc Vertical scrollbar component (top min, bottom max).
///       Public wrapper around __ReflexScrollBar.
/// @return {Struct.ReflexVScrollBar}
#endregion
function ReflexVScrollBar() : __ReflexScrollBar() constructor
{
	#region Setters

	#region jsDoc
	/// @func set_padding_left(_value)
	/// @desc Sets horizontal padding left of the grabber within the track.
	/// @param {Real} _value
	/// @return {Struct.ReflexVScrollBar}
	#endregion
	static set_padding_left = function(_value)
	{
		__track_pad_a = _value;
		return self;
	};

	#region jsDoc
	/// @func set_padding_right(_value)
	/// @desc Sets horizontal padding right of the grabber within the track.
	/// @param {Real} _value
	/// @return {Struct.ReflexVScrollBar}
	#endregion
	static set_padding_right = function(_value)
	{
		__track_pad_b = _value;
		return self;
	};

	#endregion

	#region Getters

	#region jsDoc
	/// @func get_padding_left()
	/// @desc Returns left padding.
	/// @return {Real}
	#endregion
	static get_padding_left = function() { return __track_pad_a; };

	#region jsDoc
	/// @func get_padding_right()
	/// @desc Returns right padding.
	/// @return {Real}
	#endregion
	static get_padding_right = function() { return __track_pad_b; };

	#endregion

	#region Private

	__axis = 1;
	__track_pad_a = 0.0;
	__track_pad_b = 0.0;

	#endregion
}