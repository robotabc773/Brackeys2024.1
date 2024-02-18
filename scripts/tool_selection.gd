extends Control

# Assumes that LogicGrid is a sister node
@onready var logic_grid : LogicGrid = $"../LogicGrid"

const tool_test = preload("res://scripts/tools/tool_test.gd")
const tool_a = preload("res://scripts/tools/tool_a.gd")
const tool_b = preload("res://scripts/tools/tool_b.gd")

func _on_tool_1_pressed():
	logic_grid.current_tool = tool_a.new()

func _on_tool_2_pressed():
	logic_grid.current_tool = tool_b.new()
	
func _on_tool_3_pressed():
	logic_grid.current_tool = tool_test.new()
