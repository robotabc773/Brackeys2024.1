extends RefCounted
class_name Grid

var num_rows : int
var num_cols : int
var states : Array[Tile.State]

func _init(r : int, c : int, s : Array[Tile.State]):
	assert(r * c == s.size(), "Grid improperly initialized")
	num_rows = r
	num_cols = c
	states = s

func index_to_pos(i : int) -> Vector2i:
	@warning_ignore("integer_division")
	return Vector2i(i % num_cols, i / num_cols)

func valid_pos(pos : Vector2i) -> bool:
	return pos.y >= 0 and pos.y <= num_rows - 1 and pos.x >= 0 and pos.x <= num_cols - 1

func get_state(pos : Vector2i) -> Tile.State:
	return states[pos.y * num_cols + pos.x]
	
func set_state(pos : Vector2i, state : Tile.State) -> void:
	states[pos.y * num_cols + pos.x] = state

func copy() -> Grid:
	return Grid.new(num_rows, num_cols, states.duplicate())

func neighbors(pos : Vector2i, deltas : Array[Vector2i]) -> Array[Vector2i]:
	var res : Array[Vector2i] = []
	for delta in deltas:
		if valid_pos(pos + delta):
			res.append(pos + delta)
	return res

func neighbors8(pos : Vector2i) -> Array[Vector2i]:
	return neighbors(pos, [Vector2i(-1, -1), Vector2i(-1, 0), Vector2i(-1, 1), Vector2i(0, -1), Vector2i(0, 1), Vector2i(1, -1), Vector2i(1, 0), Vector2i(1, 1)])

func neighbors4(pos : Vector2i) -> Array[Vector2i]:
	return neighbors(pos, [Vector2i(-1, 0), Vector2i(0, -1), Vector2i(0, 1), Vector2i(1, 0)])
