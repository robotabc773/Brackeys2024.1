extends Control
@onready var pauseMenu : MarginContainer = $MarginContainer

func _ready() -> void:
	pauseMenu.hide()

func hidePauseMenu() -> void:
	pauseMenu.hide()
	#Engine.time_scale = 1
	
func showPauseMenu() -> void:
	pauseMenu.show()
	#Engine.time_scale = 0

# show pause menu when the pause button is pressed
func _on_pause_pressed() -> void:
	showPauseMenu()

# hide pause menu when the resume button is pressed
func _on_resume_pressed() -> void:
	hidePauseMenu()


func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

# Go to level selection scene
func _on_levels_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level_selection.tscn")
