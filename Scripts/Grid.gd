extends RefCounted
class_name Grid
## A grid of tile states

## Number of rows in the grid
var num_rows : int
## Number of columns in the grid
var num_cols : int
## Internal array of states, should not be accessed directly
var states : Array[Tile.State]

## Constructor, initializes members
func _init(r : int, c : int, s : Array[Tile.State]):
	assert(r * c == s.size(), "Grid improperly initialized")
	num_rows = r
	num_cols = c
	states = s

## Turn an index in the states array into a position on the grid
func index_to_pos(i : int) -> Vector2i:
	@warning_ignore("integer_division")
	return Vector2i(i % num_cols, i / num_cols)

## Returns true iff the given position is inside the grid
func valid_pos(pos : Vector2i) -> bool:
	return pos.y >= 0 and pos.y <= num_rows - 1 and pos.x >= 0 and pos.x <= num_cols - 1

## Gets the state at a given position
func get_state(pos : Vector2i) -> Tile.State:
	return states[pos.y * num_cols + pos.x]

## Sets the state at a given position
func set_state(pos : Vector2i, state : Tile.State) -> void:
	states[pos.y * num_cols + pos.x] = state

## Returns a copy of the grid
func copy() -> Grid:
	return Grid.new(num_rows, num_cols, states.duplicate())

## Returns all valid positions obtained by adding a value from deltas to pos
func neighbors(pos : Vector2i, deltas : Array[Vector2i]) -> Array[Vector2i]:
	var res : Array[Vector2i] = []
	for delta in deltas:
		if valid_pos(pos + delta):
			res.append(pos + delta)
	return res

## Returns all valid positions from the 8 neighbors of pos
func neighbors8(pos : Vector2i) -> Array[Vector2i]:
	return neighbors(pos, [Vector2i(-1, -1), Vector2i(-1, 0), Vector2i(-1, 1), Vector2i(0, -1), Vector2i(0, 1), Vector2i(1, -1), Vector2i(1, 0), Vector2i(1, 1)])

## Returns all valid positions from the 4 orthogonal neighbors of pos
func neighbors4(pos : Vector2i) -> Array[Vector2i]:
	return neighbors(pos, [Vector2i(-1, 0), Vector2i(0, -1), Vector2i(0, 1), Vector2i(1, 0)])
