extends TextureRect
class_name Tile

enum TileState {EMPTY, LIGHT, DARK}

const empty_tex = preload("res://tile_empty.tres")
const dark_tex = preload("res://tile_dark.tres")
const light_tex = preload("res://tile_light.tres")

var hovered = false
var state : TileState

# Called when the node enters the scene tree for the first time.
func _ready():
	turn_empty()

func _gui_input(event):
	if event is InputEventMouseButton and event.pressed and hovered:
		if event.button_index == MOUSE_BUTTON_LEFT:
			turn_dark()
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			turn_light()

func _on_mouse_entered():
	hovered = true
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		turn_dark()
	elif Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		turn_light()

func _on_mouse_exited():
	hovered = false

func turn_empty():
	texture = empty_tex
	state = TileState.EMPTY

func turn_dark():
	texture = dark_tex
	state = TileState.DARK

func turn_light():
	texture = light_tex
	state = TileState.LIGHT
