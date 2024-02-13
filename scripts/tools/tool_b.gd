extends Tool

## Should return true iff the given position is valid to start the tool at
func valid_start_pos(_grid : Grid, _pos : Vector2i) -> bool:
	return true


## Apply the tool to the grid, returning the relevant [enum Tools.Result]
func apply(grid : Grid, path : Array[Vector2i]) -> Result:
	var result := Result.SUCCESS
	if path.size() < 4:
		result = Result.PREVIEW_ONLY
	
	for pos : Vector2i in path.slice(0, 4):
		grid.set_state(pos, Tile.invert(grid.get_state(pos)))
		
	return result
