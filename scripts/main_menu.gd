extends Control







func _on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/transition-ani.tscn")






func _on_exit_pressed() -> void:
	get_tree().quit()




func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/credits.tscn")
