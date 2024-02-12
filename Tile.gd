extends TextureRect
class_name Tile

enum TileState {EMPTY, LIGHT, DARK}

const empty_tex = preload("res://tile_empty.tres")
const dark_tex = preload("res://tile_dark.tres")
const light_tex = preload("res://tile_light.tres")

static var initial_click_state : TileState

var hovered = false
var state : TileState

# Called when the node enters the scene tree for the first time.
func _ready():
	turn_empty()

func _gui_input(event):
	if event is InputEventMouseButton and event.pressed and hovered:
		initial_click_state = state
		if event.button_index == MOUSE_BUTTON_LEFT:
			handle_dark_input()
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			handle_light_input()

func _on_mouse_entered():
	hovered = true
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		handle_dark_input()
	elif Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		handle_light_input()

func _on_mouse_exited():
	hovered = false

func turn_empty():
	texture = empty_tex
	state = TileState.EMPTY

func turn_dark():
	texture = dark_tex
	state = TileState.DARK
func handle_dark_input():
	if state == TileState.DARK:
		if initial_click_state == TileState.DARK:
			turn_empty()
	else:
		if initial_click_state != TileState.DARK:
			turn_dark()

func turn_light():
	texture = light_tex
	state = TileState.LIGHT
func handle_light_input():
	if state == TileState.LIGHT:
		if initial_click_state == TileState.LIGHT:
			turn_empty()
	else:
		if initial_click_state != TileState.LIGHT:
			turn_light()
