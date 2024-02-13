extends Tool
## [Tool] that draws an unfilled rectangle of dark squares.
## The corners must be light and the start and end row and column must both be different


## Must start on a light tile (because the corners must be light)
func valid_start_pos(grid : Grid, pos : Vector2i) -> bool:
	return grid.get_state(pos) == Tile.State.LIGHT


## Draws the unfilled rectangle
## Returns PREVIEW_ONLY if one of the corners isn't light 
## or the start and end row or column are the same
## Returns SUCCESS otherwise
func apply(grid : Grid, path : Array[Vector2i]) -> Result:
	var start_pos := path[0]
	var end_pos := path[-1]
	var result := Result.SUCCESS
	if (
			# Check if any corners are dark 
			# (don't need to check start_pos because valid_start_pos handles that)
			grid.get_state(end_pos) == Tile.State.DARK
			or grid.get_state(Vector2i(start_pos.x, end_pos.y)) == Tile.State.DARK
			or grid.get_state(Vector2i(end_pos.x, start_pos.y)) == Tile.State.DARK
			# Check that start and end row and column are different
			or start_pos.x == end_pos.x or start_pos.y == end_pos.y
	):
		result = Result.PREVIEW_ONLY
		
	var low_x := mini(start_pos.x, end_pos.x)
	var high_x := maxi(start_pos.x, end_pos.x)
	var low_y := mini(start_pos.y, end_pos.y)
	var high_y := maxi(start_pos.y, end_pos.y)
	
	for x in range(low_x, high_x + 1):
		grid.set_state(Vector2i(x, start_pos.y), Tile.State.DARK)
		grid.set_state(Vector2i(x, end_pos.y), Tile.State.DARK)
	for y in range(low_y, high_y + 1):
		grid.set_state(Vector2i(start_pos.x, y), Tile.State.DARK)
		grid.set_state(Vector2i(end_pos.x, y), Tile.State.DARK)
	
	return result
