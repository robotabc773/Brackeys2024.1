extends Control


const LogicGrid = preload("res://scripts/logic_grid.gd")
@onready var grid : LogicGrid = $Grid


func _ready() -> void:
	grid.current_tool = preload("res://scripts/tools/tool_editor.gd").new()


func _unhandled_key_input(event: InputEvent) -> void:
	if not event is InputEventKey:
		return
	var key_event : InputEventKey = event
	if not key_event.pressed:
		return
	match key_event.keycode:
		KEY_W:
			grid.num_rows -= 1
		KEY_S:
			grid.num_rows += 1
		KEY_A:
			grid.num_cols -= 1
		KEY_D:
			grid.num_cols += 1
		KEY_C:
			if key_event.ctrl_pressed:
				_copy_data()


func _copy_data() -> void:
	var data := {
		states = grid._display_grid._states,
		num_rows = grid._display_grid.num_rows,
		num_cols = grid._display_grid.num_cols,
	}
	DisplayServer.clipboard_set(JSON.stringify(data))
