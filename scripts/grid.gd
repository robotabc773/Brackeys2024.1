class_name Grid
extends RefCounted
## A grid of tile states

## Number of rows in the grid
var num_rows : int
## Number of columns in the grid
var num_cols : int

# Internal array of _states, should not be accessed directly
var _states : Array[Tile.State]
# Internal array of highlights, should not be accessed directly
var _highlights : Array[Tile.Highlight]

# Constructor, initializes members
func _init(r : int, c : int, s : Array[Tile.State], h : Array[Tile.Highlight] = []) -> void:
	assert(r * c == s.size(), "Grid improperly initialized")
	num_rows = r
	num_cols = c
	_states = s
	_highlights = h
	if not _highlights:
		_highlights.resize(s.size())
		_highlights.fill(Tile.Highlight.NONE)


## Turn an index in the _states array into a position on the grid
func index_to_pos(i : int) -> Vector2i:
	@warning_ignore("integer_division")
	return Vector2i(i % num_cols, i / num_cols)

## Turn a pos into a tile index, should rarely be used outside this class
func pos_to_index(pos : Vector2i) -> int:
	return pos.y * num_cols + pos.x

## Returns true iff the given position is inside the grid
func valid_pos(pos : Vector2i) -> bool:
	return pos.y >= 0 and pos.y <= num_rows - 1 and pos.x >= 0 and pos.x <= num_cols - 1

## Gets the state at a given position
func get_state(pos : Vector2i) -> Tile.State:
	return _states[pos_to_index(pos)]

## Sets the state at a given position
func set_state(pos : Vector2i, state : Tile.State) -> void:
	_states[pos_to_index(pos)] = state

## Gets the highlight at a given position
func get_highlight(pos : Vector2i) -> Tile.Highlight:
	return _highlights[pos_to_index(pos)]

## Sets the highlight at a given position
func set_highlight(pos : Vector2i, highlight : Tile.Highlight) -> void:
	_highlights[pos_to_index(pos)] = highlight

## Returns a copy of the grid
func copy() -> Grid:
	return Grid.new(num_rows, num_cols, _states.duplicate())


## Returns all valid positions obtained by adding a value from deltas to pos
func neighbors(pos : Vector2i, deltas : Array[Vector2i]) -> Array[Vector2i]:
	var res : Array[Vector2i] = []
	for delta : Vector2i in deltas:
		if valid_pos(pos + delta):
			res.append(pos + delta)
	return res

## Returns all valid positions from the 8 neighbors of pos
func neighbors8(pos : Vector2i) -> Array[Vector2i]:
	return neighbors(pos, [Vector2i(-1, -1), Vector2i(-1, 0), Vector2i(-1, 1), Vector2i(0, -1), Vector2i(0, 1), Vector2i(1, -1), Vector2i(1, 0), Vector2i(1, 1)])

## Returns all valid positions from the 4 orthogonal neighbors of pos
func neighbors4(pos : Vector2i) -> Array[Vector2i]:
	return neighbors(pos, [Vector2i(-1, 0), Vector2i(0, -1), Vector2i(0, 1), Vector2i(1, 0)])


## Returns a string representing the current grid as JSON
func to_json() -> String:
	var data := {
		states = _states,
		num_rows = num_rows,
		num_cols = num_cols,
	}
	return JSON.stringify(data)

static func from_json(json : String) -> Grid:
	var data : Dictionary = JSON.parse_string(json)
	var int_states : Array = data["states"]
	var states : Array[Tile.State] = []
	states.assign(int_states)
	var rows : int = data["num_rows"]
	var cols : int = data["num_cols"]
	return new(rows, cols, states)
