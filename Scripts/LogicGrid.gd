extends GridContainer
class_name LogicGrid

## Tile object that will be instantiated across the grid
const tile_template = preload("res://Objects/tile.tscn")

## Number of rows in the grid
@export_range(0, 20) var num_rows = 4
## Number of columns in the grid
@export_range(0, 20) var num_cols = 4

## Internal array of tiles, do not update directly
var tiles: Array[Tile]
## [Grid] representing the current displayed state of the tiles
var display_grid : Grid
## Position of the tile the mouse is currently over
var hovered_tile : Vector2i

## Called on start
## Initializes tiles and display_grid
func _ready():
	columns = num_cols
	
	# Initialize display_grid
	var states: Array[Tile.State] = []
	states.resize(num_rows * num_cols)
	states.fill(Tile.State.LIGHT)
	display_grid = Grid.new(num_rows, num_cols, states)
	
	# Instantiate tiles
	for i in range(num_rows * num_cols):
		var tile = tile_template.instantiate()
		add_child(tile)
		tiles.append(tile)
		tile.state = Tile.State.LIGHT
		# Get notified when the mouse hovers over the tile, with the tile's position
		tile.mouse_entered.connect(_tile_mouse_entered.bind(display_grid.index_to_pos(i)))

## Called when the mouse moves over a new tile
func _tile_mouse_entered(pos : Vector2i) -> void:
	hovered_tile = pos

## Current tool instance
var current_tool : Tools.Tool = Tools.ToolA.new()
## Whether there is currenty a tool in the process of being used
var tool_in_progress : bool
## Position the tool started in
var tool_start_pos : Vector2i
## Copy of the grid from before the current tool started being used
var tool_initial_grid : Grid
## Handles mouse input for starting and finishing tools
func _gui_input(event):
	if not event is InputEventMouseButton:
		return
	if event.pressed:
		# Mouse was pressed, start the tool if valid
		if not current_tool.valid_start_pos(display_grid, hovered_tile):
			return
		tool_in_progress = true
		tool_start_pos = hovered_tile
		tool_initial_grid = display_grid.copy()
	else:
		# Mouse was released, finish the tool if it is in progress
		if not tool_in_progress:
			return
		var tool_final_grid = tool_initial_grid.copy()
		var result = current_tool.apply(tool_final_grid, [tool_start_pos, hovered_tile])
		if result == Tools.Result.SUCCESS:
			display_grid = tool_final_grid
		else:
			display_grid = tool_initial_grid
		tool_in_progress = false

## Called every frame
func _process(_delta):
	# Update tool preview
	if tool_in_progress:
		var preview_grid = tool_initial_grid.copy()
		var result = current_tool.apply(preview_grid, [tool_start_pos, hovered_tile])
		if result != Tools.Result.FAILURE:
			display_grid = preview_grid
		
	# Actually display the states in display_grid
	for i in tiles.size():
		tiles[i].state = display_grid.states[i]
