extends GridContainer

const tile_template = preload("res://tile.tscn")

@export_range(0, 20) var num_rows = 4
@export_range(0, 20) var num_cols = 4

var tiles: Array[Tile]

# Called when the node enters the scene tree for the first time.
func _ready():
	columns = num_cols
	for i in range(num_rows * num_cols):
		var tile = tile_template.instantiate()
		add_child(tile)
		tiles.append(tile)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var empty = 0
	var light = 0
	var dark = 0
	for tile in tiles:
		if tile.state == Tile.TileState.EMPTY:
			empty += 1
		elif tile.state == Tile.TileState.LIGHT:
			light += 1
		else:
			dark += 1
	print("empty: %d light: %d dark: %d" % [empty, light, dark])

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
	
func neighbors(pos : int):
	@warning_ignore("integer_division")
	var row : int = pos / num_cols
	var col : int = pos % num_cols
	var res : Array[int] = []
	if row > 0:
		res.append(pos - num_cols)
	if row < num_rows - 1:
		res.append(pos + num_cols)
	if col > 0:
		res.append(pos - 1)
	if col < num_cols - 1:
		res.append(pos + 1)
	if row > 0 and col > 0:
		res.append(pos - num_cols - 1)
	if row > 0 and col < num_cols - 1:
		res.append(pos - num_cols + 1)
	if row < num_rows - 1 and col > 0:
		res.append(pos + num_cols - 1)
	if row < num_rows - 1 and col < num_cols - 1:
		res.append(pos + num_cols + 1)
	return res

func conway():
	var new_states: Array[Tile.TileState] = []
	for i in range(len(tiles)):
		var living_neighbors = 0 
		for neighbor_pos in neighbors(i):
			if tiles[neighbor_pos].state == Tile.TileState.DARK:
				living_neighbors += 1
		if tiles[i].state == Tile.TileState.EMPTY:
			if living_neighbors == 3:
				new_states.append(Tile.TileState.DARK)
			else:
				new_states.append(Tile.TileState.EMPTY)
		else:
			if living_neighbors < 2 or living_neighbors > 3:
				new_states.append(Tile.TileState.EMPTY)
			else:
				new_states.append(Tile.TileState.DARK)
	for i in range(len(tiles)):
		if new_states[i] == Tile.TileState.DARK:
			tiles[i].turn_dark()
		else:
			tiles[i].turn_empty()
