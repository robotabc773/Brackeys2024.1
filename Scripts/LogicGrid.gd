extends GridContainer
class_name LogicGrid

const tile_template = preload("res://Objects/tile.tscn")

@export_range(0, 20) var num_rows = 4
@export_range(0, 20) var num_cols = 4

var tiles: Array[Tile]
var display_grid : Grid
var hovered_tile : Vector2i

# Called when the node enters the scene tree for the first time.
func _ready():
	columns = num_cols
	var states: Array[Tile.State] = []
	states.resize(num_rows * num_cols)
	states.fill(Tile.State.LIGHT)
	display_grid = Grid.new(num_rows, num_cols, states)
	for i in range(num_rows * num_cols):
		var tile = tile_template.instantiate()
		add_child(tile)
		tiles.append(tile)
		tile.state = Tile.State.LIGHT
		tile.mouse_entered.connect(_tile_mouse_entered.bind(display_grid.index_to_pos(i)))

func _tile_mouse_entered(pos : Vector2i) -> void:
	hovered_tile = pos

var current_tool : Tools.Tool = Tools.ToolA.new()
var tool_in_progress : bool
var tool_start_pos : Vector2i
var tool_initial_grid : Grid
func _gui_input(event):
	if not event is InputEventMouseButton:
		return
	if event.pressed:
		if not current_tool.valid_start_pos(display_grid, hovered_tile):
			return
		tool_in_progress = true
		tool_start_pos = hovered_tile
		tool_initial_grid = display_grid.copy()
	else:
		if not tool_in_progress:
			return
		var tool_final_grid = tool_initial_grid.copy()
		var result = current_tool.apply(tool_final_grid, [tool_start_pos, hovered_tile])
		if result == Tools.Result.SUCCESS:
			display_grid = tool_final_grid
		else:
			display_grid = tool_initial_grid
		tool_in_progress = false

func _process(_delta):
	if tool_in_progress:
		display_grid = tool_initial_grid.copy()
		current_tool.apply(display_grid, [tool_start_pos, hovered_tile])
	for i in tiles.size():
		tiles[i].state = display_grid.states[i]

var running = false

func _unhandled_key_input(event):
	if not (event is InputEventKey):
		return
	if event.pressed and event.keycode == KEY_SPACE:
		if running:
			$Timer.stop()
			running = false
		else:
			$Timer.start()
			running = true
	
func _on_timer_timeout():
	conway()

func conway():
	var updated_grid = display_grid.copy()
	for col in num_cols:
		for row in num_rows:
			var pos = Vector2i(col, row)
			var living_neighbors = 0 
			for neighbor_pos in display_grid.neighbors8(pos):
				if display_grid.get_state(neighbor_pos) == Tile.State.DARK:
					living_neighbors += 1
			if display_grid.get_state(pos) == Tile.State.LIGHT:
				if living_neighbors == 3:
					updated_grid.set_state(pos, Tile.State.DARK)
				else:
					updated_grid.set_state(pos, Tile.State.LIGHT)
			else:
				if living_neighbors < 2 or living_neighbors > 3:
					updated_grid.set_state(pos, Tile.State.LIGHT)
				else:
					updated_grid.set_state(pos, Tile.State.DARK)
	display_grid = updated_grid
