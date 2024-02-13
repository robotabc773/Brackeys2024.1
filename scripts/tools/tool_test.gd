extends Tool

## Should return true iff the given position is valid to start the tool at
func valid_start_pos(_grid : Grid, _pos : Vector2i) -> bool:
	return true


## Apply the tool to the grid, returning the relevant [enum Tools.Result]
func apply(grid : Grid, path : Array[Vector2i]) -> Result:
	for pos : Vector2i in path:
		grid.set_state(pos, Tile.State.DARK)
	return Result.SUCCESS
