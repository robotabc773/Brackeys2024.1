class_name Tool
extends Resource
## Base class for a tool, shouldn't be used directly

## Possible results of tool application
enum Result {
	## Entirely invalid, should not modify the grid
	FAILURE, 
	## Invalid use, but still useful to show, may modify the grid
	PREVIEW_ONLY, 
	## Valid use, may modify the grid
	SUCCESS,
}

## Should return true iff the given position is valid to start the tool at
func valid_start_pos(_grid : Grid, _pos : Vector2i) -> bool:
	assert(false, "Unimplemented")
	return false


## Apply the tool to the grid, returning the relevant [enum Tools.Result]
func apply(_grid : Grid, _path : Array[Vector2i]) -> Result:
	assert(false, "Unimplemented")
	return Result.FAILURE
