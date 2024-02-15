extends Control

var logic_grid = preload("res://scripts/logic_grid.gd").new()

func _on_tool_1_pressed():
	logic_grid.switch_tools("res://scripts/tools/tool_a.gd")



func _on_tool_2_pressed():
	logic_grid.switch_tools("res://scripts/tools/tool_b.gd")



func _on_tool_3_pressed():
	pass # Replace with function body.
