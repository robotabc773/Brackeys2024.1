extends Object
class_name Tools

## Possible results of tool application
enum Result {
	## Entirely invalid, should not modify the grid
	FAILURE, 
	## Invalid use, but still useful to show, may modify the grid
	PREVIEW_ONLY, 
	## Valid use, may modify the grid
	SUCCESS
}

## Base class for a tool, shouldn't be used directly
class Tool:
	## Should return true iff the given position is valid to start the tool at
	func valid_start_pos(grid : Grid, pos : Vector2i) -> bool:
		assert(false, "Unimplemented")
		return false
	
	## Apply the tool to the grid, returning the relevant [enum Tools.Result]
	func apply(grid : Grid, path : Array[Vector2i]) -> Result:
		assert(false, "Unimplemented")
		return Result.FAILURE

class ToolTest extends Tool:
	## Should return true iff the given position is valid to start the tool at
	func valid_start_pos(grid : Grid, pos : Vector2i) -> bool:
		return true
	
	## Apply the tool to the grid, returning the relevant [enum Tools.Result]
	func apply(grid : Grid, path : Array[Vector2i]) -> Result:
		print(path)
		for pos in path:
			grid.set_state(pos, Tile.State.DARK)
		return Result.SUCCESS

## [Tool] that draws an unfilled rectangle of dark squares.
## The corners must be light and the start and end row and column must both be different
class ToolA extends Tool:
	## Must start on a light tile (because the corners must be light)
	func valid_start_pos(grid : Grid, pos : Vector2i) -> bool:
		return grid.get_state(pos) == Tile.State.LIGHT
	
	## Draws the unfilled rectangle
	## Returns PREVIEW_ONLY if one of the corners isn't light 
	## or the start and end row or column are the same
	## Returns SUCCESS otherwise
	func apply(grid : Grid, path : Array[Vector2i]) -> Result:
		var start_pos = path[0]
		var end_pos = path[-1]
		var result = Result.SUCCESS
		if grid.get_state(end_pos) == Tile.State.DARK or \
			grid.get_state(Vector2i(start_pos.x, end_pos.y)) == Tile.State.DARK or \
			grid.get_state(Vector2i(end_pos.x, start_pos.y)) == Tile.State.DARK:
			result = Result.PREVIEW_ONLY
		if start_pos.x == end_pos.x or start_pos.y == end_pos.y:
			result = Result.PREVIEW_ONLY
		
		var low_x = min(start_pos.x, end_pos.x)
		var high_x = max(start_pos.x, end_pos.x)
		var low_y = min(start_pos.y, end_pos.y)
		var high_y = max(start_pos.y, end_pos.y)
		
		for x in range(low_x, high_x + 1):
			grid.set_state(Vector2i(x, start_pos.y), Tile.State.DARK)
			grid.set_state(Vector2i(x, end_pos.y), Tile.State.DARK)
		for y in range(low_y, high_y + 1):
			grid.set_state(Vector2i(start_pos.x, y), Tile.State.DARK)
			grid.set_state(Vector2i(end_pos.x, y), Tile.State.DARK)
		
		return result
