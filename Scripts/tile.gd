class_name Tile
extends TextureRect
## Draws a single tile

## Possible states for a tile
enum State {LIGHT, DARK}

## Inverts a given state
static func invert(s : State) -> State:
	if s == State.DARK:
		return State.LIGHT
	else:
		return State.DARK


#const empty_tex = preload("res://Sprites/tile_empty.tres")
const dark_tex : Texture = preload("res://Sprites/tile_dark.tres")
const light_tex : Texture = preload("res://Sprites/tile_light.tres")


## The current state of the tile, setting also changes the texture
var state : State:
	set(value):
		match value:
			State.LIGHT:
				texture = light_tex
			State.DARK:
				texture = dark_tex
		state = value
