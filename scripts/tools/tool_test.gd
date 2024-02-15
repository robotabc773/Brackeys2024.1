extends Tool

## Should return true iff the given position is valid to start the tool at
func valid_start_pos(_grid : Grid, _pos : Vector2i) -> bool:
	return true


## Apply the tool to the grid, returning if the use was valid
## If returning false should not modify grid
## When preview is true, should make illegal modifications for UI purposes
## Can also highlight tiles to display information
func apply(grid : Grid, path : Array[Vector2i], preview := false) -> bool:
	for pos : Vector2i in path:
		grid.set_state(pos, Tile.State.DARK)
		if preview:
			grid.set_highlight(pos, Tile.Highlight.BLUE)
	return true
