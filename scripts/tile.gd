class_name Tile
extends TextureRect
## Draws a single tile

## Possible states for a tile
enum State {LIGHT, DARK, BLOCKED}

## Possible highlight colors
enum Highlight {NONE, RED, GREEN, BLUE}

## Inverts a given state
static func invert(s : State) -> State:
	if s == State.DARK:
		return State.LIGHT
	elif s == State.LIGHT:
		return State.DARK
	else:
		return State.BLOCKED


## Get the canonical color for a given highlight
static func highlight_to_color(h : Highlight) -> Color:
	match h:
		Highlight.NONE:
			return Color(1, 1, 1, 1)
		Highlight.RED:
			return Color(1, 0.5, 0.5, 1)
		Highlight.GREEN:
			return Color(0.5, 1, 0.5, 1)
		Highlight.BLUE:
			return Color(0.5, 0.5, 1, 1)
		_:
			assert(false, "Unimplemented highlight")
			return Color(1, 1, 1, 1)

const blocked_tex : Texture = preload("res://sprites/tile_empty.tres")
const dark_tex : Texture = preload("res://sprites/tile_dark.tres")
const light_tex : Texture = preload("res://sprites/tile_light.tres")


## The current state of the tile, setting also changes the texture
var state : State = State.LIGHT:
	set(value):
		match value:
			State.LIGHT:
				texture = light_tex
			State.DARK:
				texture = dark_tex
			State.BLOCKED:
				texture = blocked_tex
		state = value

## The current highlight color of the tile
var highlight : Highlight = Highlight.NONE:
	set(value):
		highlight = value
		modulate = highlight_to_color(highlight)
