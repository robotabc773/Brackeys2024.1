extends TextureRect
class_name Tile
## Draws a single tile

enum State {LIGHT, DARK}

#const empty_tex = preload("res://Sprites/tile_empty.tres")
const dark_tex = preload("res://Sprites/tile_dark.tres")
const light_tex = preload("res://Sprites/tile_light.tres")

var state : State:
	set(value):
		match value:
			State.LIGHT:
				texture = light_tex
			State.DARK:
				texture = dark_tex
		state = value
