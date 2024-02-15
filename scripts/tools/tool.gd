class_name Tool
extends Resource
## Base class for a tool, shouldn't be used directly


## Should return true iff the given position is valid to start the tool at
func valid_start_pos(_grid : Grid, _pos : Vector2i) -> bool:
	assert(false, "Unimplemented")
	return false


## Apply the tool to the grid, returning if the use was valid
## If returning false should not modify grid
## When preview is true, should make illegal modifications for UI purposes
## Can also highlight tiles to display information
func apply(_grid : Grid, _path : Array[Vector2i], preview := false) -> bool:
	assert(false, "Unimplemented")
	return false
