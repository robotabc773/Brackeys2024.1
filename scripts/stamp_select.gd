class_name StampSelect
extends Control

const _button_template = preload("res://objects/stamp_select_button.tscn")

var _tool_buttons : Array[TextureRect]

@onready var logic_grid : LogicGrid = %LogicGrid

func set_tools(tools : Array[Tool]) -> void:
	# Clear existing tool buttons
	for button in _tool_buttons:
		button.queue_free()
	_tool_buttons.clear()
	
	# Don't bother having buttons if there's only one tool
	if tools.size() <= 1:
		return
	
	# Create new buttons
	for tool in tools:
		var button : TextureRect = _button_template.instantiate()
		button.texture = tool.icon
		button.gui_input.connect(_handle_button.bind(tool))
		
		add_child(button)
		_tool_buttons.append(button)

func _handle_button(event : InputEvent, tool : Tool) -> void:
	if not event is InputEventMouseButton:
		return
	var mouse_event : InputEventMouseButton = event
	if mouse_event.pressed and mouse_event.button_index == MOUSE_BUTTON_LEFT:
		logic_grid.current_tool = tool
