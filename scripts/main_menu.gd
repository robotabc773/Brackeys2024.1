extends Control
var sfxPlayer := AudioStreamPlayer.new()

func _ready():
	add_child(sfxPlayer)
	var sfx = load("res://sound/sfx/UI_pop.wav")
	sfxPlayer.stream = sfx


func _on_play_pressed() -> void:
	sfxPlayer.play()
	get_tree().change_scene_to_file("res://scenes/level.tscn")



func _on_exit_pressed() -> void:
	sfxPlayer.play()
	get_tree().quit()


func _on_credits_pressed() -> void:
	sfxPlayer.play()
	get_tree().change_scene_to_file("res://scenes/credits.tscn")
