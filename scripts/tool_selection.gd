extends Control

# Assumes that LogicGrid is a sister node
@onready var logic_grid : LogicGrid = $"../LogicGrid"

const tool_test = preload("res://scripts/tools/tool_test.gd")
const tool_a = preload("res://scripts/tools/tool_a.gd")
const tool_b = preload("res://scripts/tools/tool_b.gd")
const tool_stamp = preload("res://scripts/tools/tool_stamp.gd")

func _on_tool_1_pressed():
	logic_grid.current_tool = tool_stamp.new([Vector2i(0, 0)])

func _on_tool_2_pressed():
	logic_grid.current_tool = tool_stamp.new([Vector2i(0, 0), Vector2i(-1, 0), Vector2i(1, 0), Vector2i(0, 1)])
	
func _on_tool_3_pressed():
	logic_grid.current_tool = tool_stamp.new([Vector2i(0, 0), Vector2i(-2, 0), Vector2i(-1, 0), Vector2i(0, 1)])
