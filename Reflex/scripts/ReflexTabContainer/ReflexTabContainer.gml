#region jsDoc
/// @func ReflexTabContainer(_data)
/// @desc
///   Page coordinator that pairs a ReflexTabBar with a page host.
///   - Manages page node lifecycle (add/remove/reparent)
///   - Coordinates page visibility based on TabBar selection
///   - Forwards configuration to internal TabBar
///   - Emits container-level events
///
/// @param {Struct|String|Undefined} [_data]=undefined Optional flexpanel create struct or JSON
/// @returns {Struct.ReflexTabContainer}
#endregion
function ReflexTabContainer(_data=undefined) : ReflexUI(_data) constructor
{
	// =========================================================================
	// PUBLIC API - SETTERS (Forward to TabBar)
	// =========================================================================
	
	#region jsDoc
	/// @func set_deselect_enabled(_enabled)
	/// @desc Forwards to the bound TabBar.
	/// @param {Bool} _enabled
	/// @returns {Struct.ReflexTabContainer}
	#endregion
	static set_deselect_enabled = function(_enabled)
	{
		if (__tab_bar != undefined) __tab_bar.set_deselect_enabled(_enabled);
		return self;
	};
	
	#region jsDoc
	/// @func set_tabs_rearrange_group(_group_id)
	/// @desc Forwards to the bound TabBar.
	/// @param {Real} _group_id
	/// @returns {Struct.ReflexTabContainer}
	#endregion
	static set_tabs_rearrange_group = function(_group_id)
	{
		if (__tab_bar != undefined) __tab_bar.set_rearrange_group(_group_id);
		return self;
	};
	
	#region jsDoc
	/// @func set_drag_reorder_enabled(_enabled)
	/// @desc Forwards to the bound TabBar.
	/// @param {Bool} _enabled
	/// @returns {Struct.ReflexTabContainer}
	#endregion
	static set_drag_reorder_enabled = function(_enabled)
	{
		if (__tab_bar != undefined) __tab_bar.set_drag_reorder_enabled(_enabled);
		return self;
	};
	
	#region jsDoc
	/// @func set_tabs_closable(_enabled)
	/// @desc Forwards to the bound TabBar.
	/// @param {Bool} _enabled
	/// @returns {Struct.ReflexTabContainer}
	#endregion
	static set_tabs_closable = function(_enabled)
	{
		if (__tab_bar != undefined) __tab_bar.set_tabs_closable(_enabled);
		return self;
	};
	
	// =========================================================================
	// PUBLIC API - GETTERS
	// =========================================================================
	
	#region jsDoc
	/// @func get_tab_bar()
	/// @desc Returns the currently bound TabBar.
	/// @returns {Struct.ReflexTabBar|Undefined}
	#endregion
	static get_tab_bar = function()
	{
		return __tab_bar;
	};
	
	#region jsDoc
	/// @func get_page_host()
	/// @desc Returns the page host container.
	/// @returns {Struct.ReflexUI}
	#endregion
	static get_page_host = function()
	{
		return __page_host;
	};
	
	#region jsDoc
	/// @func get_tab_count()
	/// @desc Returns bound TabBar tab count.
	/// @returns {Real}
	#endregion
	static get_tab_count = function()
	{
		if (__tab_bar == undefined) return 0;
		return __tab_bar.get_tab_count();
	};
	
	#region jsDoc
	/// @func get_current_tab()
	/// @desc Returns bound TabBar current index.
	/// @returns {Real}
	#endregion
	static get_current_tab = function()
	{
		if (__tab_bar == undefined) return -1;
		return __tab_bar.get_current_index();
	};
	
	#region jsDoc
	/// @func get_current_tab_id()
	/// @desc Returns bound TabBar current tab ID.
	/// @returns {Real}
	#endregion
	static get_current_tab_id = function()
	{
		if (__tab_bar == undefined) return -1;
		return __tab_bar.get_current_tab_id();
	};
	
	#region jsDoc
	/// @func get_tabs_rearrange_group()
	/// @desc Returns bound TabBar rearrange group id.
	/// @returns {Real}
	#endregion
	static get_tabs_rearrange_group = function()
	{
		if (__tab_bar == undefined) return 0;
		return __tab_bar.get_rearrange_group();
	};
	
	// =========================================================================
	// PUBLIC API - FUNCTIONS
	// =========================================================================
	
	#region jsDoc
	/// @func set_current_tab(_index)
	/// @desc Sets selection on the bound TabBar (and updates pages via events).
	/// @param {Real} _index
	/// @returns {Struct.ReflexTabContainer}
	#endregion
	static set_current_tab = function(_index)
	{
		if (__tab_bar == undefined) return self;
		__tab_bar.set_current_index(_index);
		__apply_selection_from_bar();
		return self;
	};
	
	#region jsDoc
	/// @func set_current_tab_by_id(_tab_id)
	/// @desc Sets selection on the bound TabBar by tab ID.
	/// @param {Real} _tab_id
	/// @returns {Struct.ReflexTabContainer}
	#endregion
	static set_current_tab_by_id = function(_tab_id)
	{
		if (__tab_bar == undefined) return self;
		__tab_bar.set_current_tab_id(_tab_id);
		__apply_selection_from_bar();
		return self;
	};
	
	#region jsDoc
	/// @func add_tab(_title, _page_node, _closable, _user_data)
	/// @desc Adds a tab to the bound TabBar. If _user_data is undefined, it defaults to _page_node.
	/// @param {String} _title Tab title
	/// @param {Struct.Reflex} _page_node Page node to display
	/// @param {Bool} [_closable]=true Whether tab is closable
	/// @param {Any} [_user_data]=undefined Optional user data (defaults to page_node)
	/// @returns {Struct.ReflexTabContainer}
	#endregion
	static add_tab = function(_title, _page_node, _closable=true, _user_data=undefined)
	{
		static __global_tab_id_counter = 0;
		__global_tab_id_counter++;
		
		var _tab_id = __global_tab_id_counter;
		var _tab_user_data = (_user_data != undefined) ? _user_data : _page_node;
		
		// Create tab struct
		var _tab = {
			tab_id: _tab_id,
			title: _title ?? $"Tab_{_tab_id}",
			enabled: true,
			visible: true,
			closable: (_closable == true),
			user_data: _tab_user_data
		};
		
		// Add to bar
		__tab_bar.add_tab(_tab, false);
		
		// Parent page node
		if (_page_node != undefined)
		{
			_page_node.add_to(__page_host);
			_page_node.set_display(flexpanel_display.none);
		}
		
		// Select first tab if none selected
		if (__tab_bar.get_current_index() < 0)
		{
			__tab_bar.set_current_index(0);
		}
		
		__apply_selection_from_bar();
		return self;
	};
	
	#region jsDoc
	/// @func insert_tab(_index, _title, _page_node, _closable, _user_data)
	/// @desc Inserts a tab at specific index.
	/// @param {Real} _index Target index
	/// @param {String} _title Tab title
	/// @param {Struct.Reflex} _page_node Page node to display
	/// @param {Bool} [_closable]=true Whether tab is closable
	/// @param {Any} [_user_data]=undefined Optional user data (defaults to page_node)
	/// @returns {Struct.ReflexTabContainer}
	#endregion
	static insert_tab = function(_index, _title, _page_node, _closable=true, _user_data=undefined)
	{
		static __global_tab_id_counter = 0;
		__global_tab_id_counter++;
		
		var _tab_id = __global_tab_id_counter;
		var _tab_user_data = (_user_data != undefined) ? _user_data : _page_node;
		
		// Create tab struct
		var _tab = {
			tab_id: _tab_id,
			title: _title ?? $"Tab_{_tab_id}",
			enabled: true,
			visible: true,
			closable: (_closable == true),
			user_data: _tab_user_data
		};
		
		// Insert into bar
		__tab_bar.insert_tab(_index, _tab, false);
		
		// Parent page node
		if (_page_node != undefined)
		{
			_page_node.add_to(__page_host);
			_page_node.set_display(flexpanel_display.none);
		}
		
		// Select first tab if none selected
		if (__tab_bar.get_current_index() < 0)
		{
			__tab_bar.set_current_index(0);
		}
		
		__apply_selection_from_bar();
		return self;
	};
	
	#region jsDoc
	/// @func remove_tab(_index)
	/// @desc Removes a tab by index from the bound TabBar.
	/// @param {Real} _index
	/// @returns {Struct.ReflexTabContainer}
	#endregion
	static remove_tab = function(_index)
	{
		if (__tab_bar == undefined) return self;
		
		var _removed = __tab_bar.remove_tab_by_index(_index);
		
		// If user_data is a page node and it was parented here, detach it
		if (_removed != undefined)
		{
			var _user_data = _removed.user_data;
			if (_user_data != undefined)
			{
				__page_host.remove(_user_data);
			}
		}
		
		__apply_selection_from_bar();
		return self;
	};
	
	#region jsDoc
	/// @func remove_tab_by_id(_tab_id)
	/// @desc Removes a tab by ID from the bound TabBar.
	/// @param {Real} _tab_id
	/// @returns {Struct.ReflexTabContainer}
	#endregion
	static remove_tab_by_id = function(_tab_id)
	{
		if (__tab_bar == undefined) return self;
		
		var _removed = __tab_bar.remove_tab_by_id(_tab_id);
		
		// If user_data is a page node and it was parented here, detach it
		if (_removed != undefined)
		{
			var _user_data = _removed.user_data;
			if (_user_data != undefined)
			{
				__page_host.remove(_user_data);
			}
		}
		
		__apply_selection_from_bar();
		return self;
	};
	
	#region jsDoc
	/// @func clear_tabs()
	/// @desc Removes all tabs from the bound TabBar.
	/// @returns {Struct.ReflexTabContainer}
	#endregion
	static clear_tabs = function()
	{
		if (__tab_bar == undefined) return self;
		
		// Get all tabs before clearing
		var _tabs = __tab_bar.get_tabs();
		var _count = array_length(_tabs);
		
		// Detach all pages
		for (var _i = 0; _i < _count; _i++)
		{
			var _user_data = _tabs[_i].user_data;
			if (_user_data != undefined)
			{
				__page_host.remove(_user_data);
			}
		}
		
		// Clear bar
		__tab_bar.clear_tabs();
		
		__apply_selection_from_bar();
		return self;
	};
	
	#region jsDoc
	/// @func add(_child_node)
	/// @desc Children-as-pages authoring: adding a child routes it as a new tab (title from name).
	/// @param {Struct.Reflex} _child_node
	/// @returns {Struct.ReflexTabContainer}
	#endregion
	static add = function(_child_node)
	{
		var _title = "";
		if (_child_node != undefined && variable_struct_exists(_child_node, "get_name"))
		{
			_title = _child_node.get_name();
		}
		if (_title == "") _title = "Tab";
		
		add_tab(_title, _child_node, true, undefined);
		return self;
	};
	
	// =========================================================================
	// EVENTS
	// =========================================================================
	
	events = {};
	events.tab_changed = variable_get_hash("tab_changed");
	events.tab_close_requested = variable_get_hash("tab_close_requested");
	events.tab_transferred = variable_get_hash("tab_transferred");
	
	#region jsDoc
	/// @func on_tab_changed(_func)
	/// @desc Adds a listener for selection changes (index, tab_id).
	/// @param {Function} _func Callback receives { index, tab_id, container }
	/// @returns {Struct.ReflexTabContainer}
	#endregion
	static on_tab_changed = function(_func)
	{
		__add_event_listener(events.tab_changed, _func);
		return self;
	};
	
	#region jsDoc
	/// @func on_tab_close_requested(_func)
	/// @desc Adds a listener for close requested.
	/// @param {Function} _func Callback receives { index, tab_id, container }
	/// @returns {Struct.ReflexTabContainer}
	#endregion
	static on_tab_close_requested = function(_func)
	{
		__add_event_listener(events.tab_close_requested, _func);
		return self;
	};
	
	#region jsDoc
	/// @func on_tab_transferred(_func)
	/// @desc Adds a listener for tab transfers affecting the bound bar.
	/// @param {Function} _func Callback receives { tab_id, from_bar, to_bar, to_index, container }
	/// @returns {Struct.ReflexTabContainer}
	#endregion
	static on_tab_transferred = function(_func)
	{
		__add_event_listener(events.tab_transferred, _func);
		return self;
	};
	
	// =========================================================================
	// PRIVATE STATE
	// =========================================================================
	
	// Track page nodes by tab_id for efficient lookup
	__page_nodes_by_id = {};
	
	// =========================================================================
	// INTERNAL NODES
	// =========================================================================
	
	// Set container layout
	set_flex_direction(flexpanel_flex_direction.column);
	
	// Create internal TabBar
	__tab_bar = new ReflexTabBar();
	__base_add = ReflexUI.add;
	__base_add(__tab_bar);
	
	// Create page host
	__page_host = new ReflexUI();
	__base_add(__page_host);
	__page_host.set_flex_grow(1);
	__page_host.set_flex_basis(0);
	
	// =========================================================================
	// EVENT WIRING
	// =========================================================================
	
	// Wire TabBar events to container
	__tab_bar.on_tab_requested(method(self, function(_data)
	{
		__apply_selection_from_bar();
	}));
	
	__tab_bar.on_selection_changed(method(self, function(_data)
	{
		__apply_selection_from_bar();
	}));
	
	__tab_bar.on_close_requested(method(self, function(_data)
	{
		// Emit close_requested event (user decides whether to remove)
		__trigger_event(events.tab_close_requested, { 
			index: _data.index, 
			tab_id: _data.tab_id, 
			container: self 
		});
	}));
	
	__tab_bar.on_tabs_changed(method(self, function(_data)
	{
		__refresh_page_host_from_bar();
		__apply_selection_from_bar();
	}));
	
	__tab_bar.on_transfer_requested(method(self, function(_data)
	{
		// Tab has transferred between bars
		// If destination bar belongs to a container, that container will handle reparenting
		__refresh_page_host_from_bar();
		__apply_selection_from_bar();
		
		// Emit transfer event
		__trigger_event(events.tab_transferred, { 
			tab_id: _data.tab_id, 
			from_bar: _data.from_bar, 
			to_bar: _data.to_bar, 
			to_index: _data.to_index, 
			container: self 
		});
		
		// If we're the destination, try to adopt the page node
		if (_data.to_bar == __tab_bar)
		{
			__refresh_page_host_from_bar();
		}
	}));
	
	// =========================================================================
	// PRIVATE METHODS
	// =========================================================================
	
	#region jsDoc
	/// @func __refresh_page_host_from_bar()
	/// @desc Ensures user_data nodes that are Reflex nodes are parented under page_host.
	#endregion
	static __refresh_page_host_from_bar = function()
	{
		if (__tab_bar == undefined) return;
		
		var _tabs = __tab_bar.get_tabs();
		var _count = array_length(_tabs);
		
		// Rebuild page node tracking
		__page_nodes_by_id = {};
		
		for (var _i = 0; _i < _count; _i++)
		{
			var _user_data = _tabs[_i].user_data;
			if (_user_data != undefined && is_instanceof(_user_data, Reflex))
			{
				// Parent under page host
				_user_data.add_to(__page_host);
				_user_data.set_display(flexpanel_display.none);
				
				// Track by tab_id
				__page_nodes_by_id[$ _tabs[_i].tab_id] = _user_data;
			}
		}
	};
	
	#region jsDoc
	/// @func __apply_selection_from_bar()
	/// @desc Shows the selected user_data page (if it's a Reflex node), hides others.
	#endregion
	static __apply_selection_from_bar = function()
	{
		if (__tab_bar == undefined) return;
		
		var _tabs = __tab_bar.get_tabs();
		var _count = array_length(_tabs);
		var _sel = __tab_bar.get_current_index();
		
		// Hide all page nodes
		for (var _i = 0; _i < _count; _i++)
		{
			var _user_data = _tabs[_i].user_data;
			if (_user_data != undefined && is_instanceof(_user_data, Reflex))
			{
				_user_data.set_display(flexpanel_display.none);
			}
		}
		
		// Show selected
		if (_sel >= 0 && _sel < _count)
		{
			var _user_data = _tabs[_sel].user_data;
			if (_user_data != undefined && is_instanceof(_user_data, Reflex))
			{
				_user_data.set_display(flexpanel_display.flex);
			}
		}
		
		// Emit tab_changed event
		var _tab_id = (_sel >= 0 && _sel < _count) ? _tabs[_sel].tab_id : -1;
		__trigger_event(events.tab_changed, { 
			index: _sel, 
			tab_id: _tab_id, 
			container: self 
		});
	};
}
