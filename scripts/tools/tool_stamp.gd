extends Tool
## Tool that stamps a rotatable pattern onto the grid,
## flipping the relevant tiles


## Current tool rotation
var _rotation := 0
## Stamp deltas
var _deltas : Array[Vector2i]:
	get:
		var rotated : Array[Vector2i] = _deltas.duplicate()
		for i in rotated.size():
			var delta := rotated[i]
			match _rotation:
				1:
					rotated[i] = Vector2i(-delta.y, delta.x)
				2:
					rotated[i] = Vector2i(-delta.x, -delta.y)
				3:
					rotated[i] = Vector2i(delta.y, -delta.x)
		return rotated


func _init(d : Array[Vector2i]) -> void:
	_deltas = d
	one_click = true


## One click tools are always valid
func valid_start_pos(_grid : Grid, _pos : Vector2i) -> bool:
	return true


## On preview: highlight the tiles to be changed, green if valid, red if not
## On apply: flip the tiles
func apply(grid : Grid, path : Array[Vector2i], preview := false) -> bool:
	var tiles := grid.neighbors(path[0], _deltas)
	var valid := tiles.size() == _deltas.size() and tiles.all(func(p : Vector2i): return grid.get_state(p) != Tile.State.BLOCKED)
	if preview:
		for t in tiles:
			grid.set_highlight(t, Tile.Highlight.GREEN if valid else Tile.Highlight.RED)
		return true
		
	if valid:
		for t in tiles:
			grid.set_state(t, Tile.invert(grid.get_state(t)))
		return true

	return false

## Rotate the tool
func rotate(ccw := false) -> void:
	if ccw:
		_rotation += 4 - 1
	else:
		_rotation += 1
	_rotation %= 4
	print(_rotation)
