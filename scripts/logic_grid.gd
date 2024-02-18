class_name LogicGrid
extends GridContainer

# Tile object that will be instantiated across the grid
const _tile_template = preload("res://objects/tile.tscn")

## Number of rows in the grid
@export_range(0, 20) var num_rows : int = 4:
	set(value):
		if value < 1:
			return
		num_rows = value
		resize()
## Number of columns in the grid
@export_range(0, 20) var num_cols : int = 4:
	set(value):
		if value < 1:
			return
		num_cols = value
		resize()

## Current tool instance
var current_tool : Tool = preload("res://scripts/tools/tool_test.gd").new():
	set(value):
		cancel_tool()
		current_tool = value

# Internal array of tiles, generally do not update directly
var _tiles: Array[Tile]
# Grid representing the current displayed state of the tiles
var _display_grid : Grid
# Position of the tile the mouse is currently over
var _hovered_tile : Vector2i

# Whether there is currenty a tool in the process of being used
var _tool_in_progress : bool
# Copy of the grid from before the current tool started being used
var _tool_initial_grid : Grid
# Path the mouse has taken over the course of the current tool
var _tool_path : Array[Vector2i]

# Stack of previous grids for undo to use
var _undo_history : Array[UndoState]

# Called on start
func _ready() -> void:
	# Ensure the grid exists
	resize()
	# Save the initial state as the earliest state to undo to
	_undo_history = [UndoState.new(_display_grid)]
	_tool_initial_grid = _display_grid.copy()


# Adds a position to the tool path, backtracking if we've already visited it
func _add_pos_to_tool_path(pos : Vector2i) -> void:
	var existing_index := _tool_path.find(pos)
	if existing_index != -1:
		# We've gone backwards
		_tool_path.resize(existing_index + 1)
	else:
		_tool_path.append(pos)


# Called when the mouse moves over a new tile
func _tile_mouse_entered(pos : Vector2i) -> void:
	if _tool_in_progress:
		# Step towards pos incrementally to ensure only orthogonal movements
		var old_pos := _tool_path[-1]
		while old_pos != pos:
			var delta := pos - old_pos
			if absi(delta.x) > absi(delta.y):
				old_pos.x += signi(delta.x)
			else:
				old_pos.y += signi(delta.y)
			_add_pos_to_tool_path(old_pos)
		_add_pos_to_tool_path(pos)
	_hovered_tile = pos
	if current_tool.one_click:
		_tool_path = [_hovered_tile]


# Handles mouse input for starting and finishing tools
func _gui_input(event : InputEvent) -> void:
	if not event is InputEventMouseButton:
		return
	var mouse_event : InputEventMouseButton = event
	if mouse_event.button_index == MOUSE_BUTTON_LEFT:
		if mouse_event.pressed:
			# Mouse was pressed, start the tool if valid
			_start_tool()
		else:
			# Mouse was released, finish the tool
			_end_tool()
	elif mouse_event.button_index == MOUSE_BUTTON_RIGHT and mouse_event.pressed:
		# Undo on right-click
		_undo()


func _unhandled_key_input(event: InputEvent) -> void:
	if not event is InputEventKey:
		return
	var key_event : InputEventKey = event
	if key_event.pressed:
		match key_event.keycode:
			KEY_R:
				current_tool.rotate()
			KEY_Q:
				current_tool.rotate(true)

# Called every frame
func _process(_delta : float) -> void:
	# Update tool preview
	if _tool_in_progress or current_tool.one_click:
		var preview_grid := _tool_initial_grid.copy()
		var success := current_tool.apply(preview_grid, _tool_path, true)
		if success:
			_display_grid = preview_grid
		
	# Actually display the states in _display_grid
	for i in _tiles.size():
		_tiles[i].state = _display_grid.get_state(_display_grid.index_to_pos(i))
		_tiles[i].highlight = _display_grid.get_highlight(_display_grid.index_to_pos(i))


# Resizes/creates the grid
func resize() -> void:
	columns = num_cols
	
	# Create new _display_grid
	var states: Array[Tile.State] = []
	states.resize(num_rows * num_cols)
	states.fill(Tile.State.LIGHT)
	var new_display_grid := Grid.new(num_rows, num_cols, states)
	
	# Copy over old _display_grid
	if _display_grid:
		for row in num_rows:
			for col in num_cols:
				var pos := Vector2i(col, row)
				if _display_grid.valid_pos(pos):
					new_display_grid.set_state(pos, _display_grid.get_state(pos))
	
	_display_grid = new_display_grid
	
	# Destroy old tiles
	for tile in _tiles:
		tile.queue_free()
	
	# Instantiate tiles
	_tiles = []
	for i in range(num_rows * num_cols):
		var tile : Tile = _tile_template.instantiate()
		#var tile : Tile = preload("res://scripts/tile.gd").new()
		add_child(tile)
		_tiles.append(tile)
		tile.state = _display_grid.get_state(_display_grid.index_to_pos(i))
		# Get notified when the mouse hovers over the tile, with the tile's position
		tile.mouse_entered.connect(_tile_mouse_entered.bind(_display_grid.index_to_pos(i)))


# Start the current tool
func _start_tool() -> void:
	if current_tool.one_click:
		_tool_in_progress = true
		_end_tool()
		return
	
	if not current_tool.valid_start_pos(_display_grid, _hovered_tile):
		return
	_tool_in_progress = true
	_tool_initial_grid = _display_grid.copy()
	_tool_path = [_hovered_tile]


# End the current tool, committing its results if they are valid
func _end_tool() -> void:
	if not _tool_in_progress:
		return
		
	var tool_final_grid := _tool_initial_grid.copy()
	var success := current_tool.apply(tool_final_grid, _tool_path)
	if success:
		_display_grid = tool_final_grid
		_undo_history.append(UndoState.new(_tool_initial_grid.copy()))
		_tool_initial_grid = _display_grid.copy()
	else:
		_display_grid = _tool_initial_grid
		
	_tool_in_progress = false
	

# Cancel the current tool, always discarding the current results
func cancel_tool() -> void:
	_display_grid = _tool_initial_grid
	_tool_path = [_hovered_tile]
	_tool_in_progress = false


class UndoState:
	var grid : Grid
	
	func _init(g : Grid) -> void:
		grid = g


# Undo the last successful move
func _undo() -> void:
	# Don't allow undos midway through a tool
	if _tool_in_progress:
		return
	# There needs to actually be something to undo (other than the initial state)
	if _undo_history.size() <= 1:
		return
	
	# Get the last state in the history
	var state : UndoState = _undo_history[-1]
	# Remove the obtained state
	_undo_history.resize(_undo_history.size() - 1)
	
	# Restore the state
	_display_grid = state.grid
	_tool_initial_grid = _display_grid.copy()
