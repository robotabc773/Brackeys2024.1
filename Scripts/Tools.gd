extends Object
class_name Tools

enum Result {FAILURE, PREVIEW_ONLY, SUCCESS}

class Tool:
	func valid_start_pos(grid : Grid, pos : Vector2i) -> bool:
		assert(false, "Unimplemented")
		return false
	
	func apply(grid : Grid, path : Array[Vector2i]) -> Result:
		assert(false, "Unimplemented")
		return Result.FAILURE

class ToolA extends Tool:
	func valid_start_pos(grid : Grid, pos : Vector2i) -> bool:
		return grid.get_state(pos) == Tile.State.LIGHT
	
	func apply(grid : Grid, path : Array[Vector2i]) -> Result:
		var start_pos = path[0]
		var end_pos = path[-1]
		var result = Result.SUCCESS
		if grid.get_state(end_pos) == Tile.State.DARK:
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
