extends AspectRatioContainer

@onready var grid : LogicGrid = $Grid


func _ready() -> void:
	grid.current_tool = preload("res://scripts/tools/tool_editor.gd").new()


func _process(_delta: float) -> void:
	ratio = float(grid.num_cols) / (grid.num_rows)


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
	DisplayServer.clipboard_set(grid._display_grid.to_json())
