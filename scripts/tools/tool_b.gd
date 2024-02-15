extends Tool

## Should return true iff the given position is valid to start the tool at
func valid_start_pos(_grid : Grid, _pos : Vector2i) -> bool:
	return true


## Apply the tool to the grid, returning the relevant [enum Tools.Result]
func apply(grid : Grid, path : Array[Vector2i], preview := false) -> bool:
	if not preview and path.size() < 4:
		return false
	
	for pos : Vector2i in path.slice(0, 4):
		grid.set_state(pos, Tile.invert(grid.get_state(pos)))
		if preview:
			if path.size() < 4:
				grid.set_highlight(pos, Tile.Highlight.RED)
			else:
				grid.set_highlight(pos, Tile.Highlight.GREEN)
		
	return true
