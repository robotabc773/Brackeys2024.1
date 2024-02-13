class_name LogicGrid
extends GridContainer

## Tile object that will be instantiated across the grid
const _tile_template = preload("res://Objects/tile.tscn")

## Number of rows in the grid
@export_range(0, 20) var num_rows : int = 4
## Number of columns in the grid
@export_range(0, 20) var num_cols : int = 4

## Current tool instance
var current_tool : Tools.Tool = Tools.ToolA.new()

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


# Called on start
# Initializes _tiles and _display_grid
func _ready() -> void:
	columns = num_cols
	
	# Initialize _display_grid
	var states: Array[Tile.State] = []
	states.resize(num_rows * num_cols)
	states.fill(Tile.State.LIGHT)
	_display_grid = Grid.new(num_rows, num_cols, states)
	
	# Instantiate tiles
	for i in range(num_rows * num_cols):
		var tile : Tile = _tile_template.instantiate()
		add_child(tile)
		_tiles.append(tile)
		tile.state = Tile.State.LIGHT
		# Get notified when the mouse hovers over the tile, with the tile's position
		tile.mouse_entered.connect(_tile_mouse_entered.bind(_display_grid.index_to_pos(i)))


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


# Handles mouse input for starting and finishing tools
func _gui_input(event : InputEvent) -> void:
	if not event is InputEventMouseButton:
		return
	var mouse_event : InputEventMouseButton = event
	if mouse_event.pressed:
		# Mouse was pressed, start the tool if valid
		if not current_tool.valid_start_pos(_display_grid, _hovered_tile):
			return
		_tool_in_progress = true
		_tool_initial_grid = _display_grid.copy()
		_tool_path = [_hovered_tile]
	else:
		# Mouse was released, finish the tool if it is in progress
		if not _tool_in_progress:
			return
		var tool_final_grid := _tool_initial_grid.copy()
		var result := current_tool.apply(tool_final_grid, _tool_path)
		if result == Tools.Result.SUCCESS:
			_display_grid = tool_final_grid
		else:
			_display_grid = _tool_initial_grid
		_tool_in_progress = false


# Called every frame
func _process(_delta : float) -> void:
	# Update tool preview
	if _tool_in_progress:
		var preview_grid := _tool_initial_grid.copy()
		var result := current_tool.apply(preview_grid, _tool_path)
		if result != Tools.Result.FAILURE:
			_display_grid = preview_grid
		
	# Actually display the states in _display_grid
	for i in _tiles.size():
		_tiles[i].state = _display_grid.get_state(_display_grid.index_to_pos(i))
