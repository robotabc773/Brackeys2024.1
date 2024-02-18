extends Node2D
var timer = 0
@export var time_to_move = 0
@export var speed = 1200

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer += delta
	if timer >= time_to_move:
		position.x += speed * delta
