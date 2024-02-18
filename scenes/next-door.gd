extends Node2D
var timer = 0
@export var time_to_move = 2.2
@export var speed = 1.25

@export var level = "res://scenes/level.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer += delta
	if scale.x >= 11.2:
		await get_tree().create_timer(0.2).timeout
		get_tree().change_scene_to_file(level)
	if timer >= time_to_move:
		scale += Vector2((speed + timer) * delta, (speed + timer) * delta)
