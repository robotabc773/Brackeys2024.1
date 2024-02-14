extends Control
@onready var pauseMenu = $MarginContainer

func _ready():
	pauseMenu.hide()

func hidePauseMenu():
	pauseMenu.hide()
	Engine.time_scale = 1
	
func showPauseMenu():
	pauseMenu.show()
	Engine.time_scale = 0

# show pause menu when the pause button is pressed
func _on_pause_pressed():
	showPauseMenu()

# hide pause menu when the resume button is pressed
func _on_resume_pressed():
	hidePauseMenu()


func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

# Go to level selection scene
func _on_levels_pressed():
	get_tree().change_scene_to_file("res://scenes/level_selection.tscn")
