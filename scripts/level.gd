class_name Level
extends RefCounted


var initial_grid : Grid
var final_grid : Grid
var possible_tools : Array[Tool]


func _init(tools : Array[Tool], init_grid : Grid) -> void:
	initial_grid = init_grid.copy()
	possible_tools = tools
	
	final_grid = initial_grid.copy()
	for row in final_grid.num_rows:
		for col in final_grid.num_cols:
			var pos := Vector2i(col, row)
			if final_grid.get_state(pos) == Tile.State.LIGHT:
				final_grid.set_state(pos, Tile.State.DARK)
