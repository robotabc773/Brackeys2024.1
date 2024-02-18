extends Tool


## Should return true iff the given position is valid to start the tool at
func valid_start_pos(_grid : Grid, _pos : Vector2i) -> bool:
	return true


## Apply the tool to the grid
func apply(grid : Grid, path : Array[Vector2i], _preview := false) -> bool:
	var first_state := grid.get_state(path[0])
	for pos in path:
		var state := grid.get_state(pos)
		if state == first_state:
			if state == Tile.State.BLOCKED:
				grid.set_state(pos, Tile.State.LIGHT)
			else:
				grid.set_state(pos, Tile.State.BLOCKED)
	return true
