extends Control

const tool_stamp = preload("res://scripts/tools/tool_stamp.gd")
var stamp_dot : Tool = tool_stamp.new([Vector2i(0, 0)])
var stamp_pair : Tool = tool_stamp.new([Vector2i(0, 0), Vector2i(1, 0)])
var stamp_three : Tool = tool_stamp.new([Vector2i(-1, 0), Vector2i(0, 0), Vector2i(1, 0)])
var stamp_long_distance : Tool = tool_stamp.new([Vector2i(0, 0), Vector2i(3, 1)])
var stamp_corners : Tool = tool_stamp.new([Vector2i(0, 0), Vector2i(1, 1)])
var stamp_short_distance : Tool = tool_stamp.new([Vector2i(0, 0), Vector2i(2, 1)])
var stamp_L : Tool = tool_stamp.new([Vector2i(0, 0), Vector2i(0, 1), Vector2i(1, 0), Vector2i(2, 0)])
var stamp_I : Tool = tool_stamp.new([Vector2i(0, 0), Vector2i(1, 0), Vector2i(2, 0), Vector2i(3, 0)])
var stamp_T : Tool = tool_stamp.new([Vector2i(0, 0), Vector2i(-1, 0), Vector2i(1, 0), Vector2i(0, 1)])
var stamp_S : Tool = tool_stamp.new([Vector2i(0, 0), Vector2i(-1, 0), Vector2i(0, 1), Vector2i(1, 1)])
var stamp_J : Tool = tool_stamp.new([Vector2i(0, 0), Vector2i(-2, 0), Vector2i(-1, 0), Vector2i(0, 1)])
var stamp_corner : Tool = tool_stamp.new([Vector2i(0, 0), Vector2i(0, 1), Vector2i(1, 0)])
var stamp_empty_1 : Tool = tool_stamp.new([Vector2i(-1, -1), Vector2i(-1, 0), Vector2i(-1, 1), Vector2i(-1, 2), Vector2i(0, -1), Vector2i(0, 0), Vector2i(0, 1), Vector2i(0, 2), Vector2i(1, -1), Vector2i(1, 0), Vector2i(1, 1), Vector2i(1, 2), Vector2i(2, 0), Vector2i(2, 1), Vector2i(2, 2)])
var stamp_empty_2 : Tool = tool_stamp.new([Vector2i(-1, -1), Vector2i(-1, 0), Vector2i(-1, 1), Vector2i(-1, 2), Vector2i(0, -1), Vector2i(0, 0), Vector2i(0, 1), Vector2i(0, 2), Vector2i(1, -1), Vector2i(1, 1), Vector2i(1, 2), Vector2i(2, -1), Vector2i(2, 0), Vector2i(2, 1), Vector2i(2, 2)])
var stamp_empty_3 : Tool = tool_stamp.new([Vector2i(-1, -1), Vector2i(-1, 0), Vector2i(-1, 1), Vector2i(-1, 2), Vector2i(0, -1), Vector2i(0, 0), Vector2i(0, 1), Vector2i(0, 2), Vector2i(1, -1), Vector2i(1, 0), Vector2i(1, 1), Vector2i(1, 2), Vector2i(2, -1), Vector2i(2, 0), Vector2i(2, 2)])
var stamp_empty_4 : Tool = tool_stamp.new([Vector2i(-1, -1), Vector2i(-1, 0), Vector2i(-1, 1), Vector2i(-1, 2), Vector2i(0, -1), Vector2i(0, 0), Vector2i(0, 1), Vector2i(0, 2), Vector2i(1, -1), Vector2i(1, 0), Vector2i(1, 1), Vector2i(1, 2), Vector2i(2, -1), Vector2i(2, 1), Vector2i(2, 2)])
var stamp_morse : Tool = tool_stamp.new([Vector2i(0, 0), Vector2i(2, 0), Vector2i(3, 0)])

var levels : Array[Level] = [
	#Level.new("", [], Grid.from_json('')),
	Level.new("Left Click", [stamp_dot], Grid.from_json('{"num_cols":3,"num_rows":3,"states":[2,2,2,2,0,2,2,2,2]}')),
	#Level.new("Fill it", [stamp_dot], Grid.from_json('{"num_cols":4,"num_rows":3,"states":[2,2,2,2,2,0,0,2,2,2,2,2]}')),
	Level.new("Arrow keys", [stamp_pair], Grid.from_json('{"num_cols":9,"num_rows":4,"states":[2,2,2,2,2,2,2,2,2,2,0,0,0,0,0,0,0,2,2,0,0,0,0,0,0,0,2,2,2,2,2,2,2,2,2,2]}')),
	Level.new("Right Click Undo, R Restart", [stamp_pair], Grid.from_json('{"num_cols":8,"num_rows":6,"states":[2,2,2,2,2,2,2,2,2,0,0,0,0,0,0,2,2,2,0,0,2,0,2,2,2,0,2,0,0,0,0,2,2,0,0,0,0,0,0,2,2,2,2,2,2,2,2,2]}')),
	Level.new("Flipping", [stamp_pair], Grid.from_json('{"num_cols":6,"num_rows":6,"states":[2,2,2,2,2,2,2,0,0,0,0,2,2,2,0,2,0,2,2,0,0,0,0,2,2,2,0,2,0,2,2,2,2,2,2,2]}')),
	#Level.new("Multiple stamps!", [stamp_T, stamp_J], Grid.from_json('{"num_cols":4,"num_rows":4,"states":[0,0,0,0,2,0,2,0,2,0,0,0,0,0,0,2]}')),
	Level.new("Rectangle", [stamp_three], Grid.from_json('{"num_cols":10,"num_rows":5,"states":[2,2,2,2,2,2,2,2,2,2,2,0,0,0,0,0,0,0,0,2,2,0,2,2,2,2,2,2,0,2,2,0,0,0,0,0,0,0,0,2,2,2,2,2,2,2,2,2,2,2]}')),
	Level.new("Cancellation", [stamp_three, stamp_I], Grid.from_json('{"num_cols":9,"num_rows":5,"states":[2,2,2,2,2,2,2,2,2,2,0,0,0,0,0,0,0,2,2,0,2,2,2,2,2,0,2,2,0,0,0,0,0,0,0,2,2,2,2,2,2,2,2,2,2]}')),
	Level.new("A=B", [stamp_pair, stamp_three], Grid.from_json('{"num_cols":9,"num_rows":12,"states":[2,2,2,2,2,2,2,2,2,2,0,0,0,2,0,0,0,2,2,0,2,0,2,0,2,0,2,2,0,2,0,2,0,0,0,2,2,0,2,0,2,0,2,0,2,2,0,2,0,0,0,2,0,2,2,0,2,0,2,0,2,0,2,2,0,2,0,0,0,2,0,2,2,0,0,0,2,0,2,0,2,2,0,2,0,2,0,2,0,2,2,0,2,0,2,0,0,0,2,2,2,2,2,2,2,2,2,2]}')),
	Level.new("Long Distance", [stamp_long_distance, stamp_corners], Grid.from_json('{"num_cols":7,"num_rows":7,"states":[2,2,2,2,2,2,2,2,0,0,2,0,0,2,2,0,0,2,0,0,2,2,2,2,2,2,2,2,2,0,0,2,0,0,2,2,0,0,2,0,0,2,2,2,2,2,2,2,2]}')),
	Level.new("Short Distance", [stamp_short_distance], Grid.from_json('{"num_cols":10,"num_rows":6,"states":[2,2,2,2,2,2,2,2,2,2,2,2,0,0,0,2,0,2,0,2,2,0,0,0,2,0,0,0,2,2,2,0,0,0,2,0,0,0,0,2,2,0,2,2,0,0,0,0,0,2,2,2,2,2,2,2,2,2,2,2]}')),
	Level.new("Morse", [stamp_morse], Grid.from_json('{"num_cols":6,"num_rows":7,"states":[2,2,2,2,2,2,2,2,0,2,2,2,2,0,0,2,0,2,2,0,0,0,0,2,2,0,0,0,0,2,2,0,2,0,0,2,2,2,2,2,2,2]}')),
	Level.new("2x2", [stamp_corner], Grid.from_json('{"num_cols":4,"num_rows":4,"states":[2,2,2,2,2,0,0,2,2,0,0,2,2,2,2,2]}')),
	Level.new("L", [stamp_L], Grid.from_json('{"num_cols":6,"num_rows":6,"states":[2,2,2,2,2,2,2,0,0,0,0,2,2,0,0,0,0,2,2,0,0,0,0,2,2,0,0,0,0,2,2,2,2,2,2,2]}')),
	Level.new("I", [stamp_I], Grid.from_json('{"num_cols":6,"num_rows":6,"states":[2,2,2,2,2,2,2,0,0,0,0,2,2,0,0,0,0,2,2,0,0,0,0,2,2,0,0,0,0,2,2,2,2,2,2,2]}')),
	Level.new("T", [stamp_T], Grid.from_json('{"num_cols":6,"num_rows":6,"states":[2,2,2,2,2,2,2,0,0,0,0,2,2,0,0,0,0,2,2,0,0,0,0,2,2,0,0,0,0,2,2,2,2,2,2,2]}')),
	Level.new("S", [stamp_S], Grid.from_json('{"num_cols":6,"num_rows":6,"states":[2,2,2,2,2,2,2,0,0,0,0,2,2,0,0,0,0,2,2,0,0,0,0,2,2,0,0,0,0,2,2,2,2,2,2,2]}')),
	Level.new("Maze", [stamp_I, stamp_J, stamp_L], Grid.from_json('{"num_cols":12,"num_rows":9,"states":[2,2,2,2,2,2,2,2,2,2,2,2,2,0,0,0,0,0,0,2,0,0,0,2,2,0,2,2,2,2,0,2,0,2,0,2,2,0,2,0,0,0,0,2,0,2,0,2,2,0,2,0,2,2,2,2,0,2,0,2,2,0,2,0,0,0,0,0,0,2,0,2,2,0,2,2,2,2,2,2,2,2,0,2,2,0,0,0,0,0,0,0,0,0,0,2,2,2,2,2,2,2,2,2,2,2,2,2]}')),
	Level.new("Tight", [stamp_T, stamp_J], Grid.from_json('{"num_cols":6,"num_rows":6,"states":[2,2,2,2,2,2,2,0,0,0,0,2,2,0,2,0,0,2,2,0,0,0,0,2,2,0,2,0,0,2,2,2,2,2,2,2]}')),
	#Level.new("J", [stamp_J], Grid.from_json('{"num_cols":10,"num_rows":10,"states":[2,2,2,2,2,2,2,2,2,2,2,0,0,0,2,0,0,0,0,2,2,0,2,0,2,2,0,0,0,2,2,0,0,0,0,0,0,0,0,2,2,2,2,0,2,0,2,0,0,2,2,0,0,0,0,0,0,0,2,2,2,0,2,0,0,0,0,0,2,2,2,0,0,0,0,2,0,0,0,2,2,0,0,0,0,0,0,0,0,2,2,2,2,2,2,2,2,2,2,2]}')),
	Level.new("Empty", [stamp_empty_1, stamp_empty_2, stamp_empty_3, stamp_empty_4], Grid.from_json('{"num_cols":6,"num_rows":6,"states":[2,2,2,2,2,2,2,0,0,0,0,2,2,0,0,0,0,2,2,0,0,0,0,2,2,0,0,0,0,2,2,2,2,2,2,2]}')),
	Level.new("Unlock", [stamp_J], Grid.from_json('{"num_cols":11,"num_rows":5,"states":[2,2,2,2,2,2,2,2,2,2,2,2,0,0,0,2,2,2,2,2,2,2,2,0,2,0,0,0,0,0,0,0,2,2,0,0,0,2,2,0,2,2,0,2,2,2,2,2,2,2,2,2,2,2,2]}')),
]

var current_level : int

@onready var logic_grid : LogicGrid = %LogicGrid
@onready var logic_grid_container : AspectRatioContainer = %"LogicGrid/.."
@onready var stamp_select : StampSelect = %StampSelect
@onready var level_title : Label = %LevelTitle

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_level(0)


func _unhandled_key_input(event: InputEvent) -> void:
	if not event is InputEventKey:
		return
	var key_event : InputEventKey = event
	if key_event.pressed:
		match key_event.keycode:
			KEY_R:
				load_level(current_level)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var level := levels[current_level]

	if logic_grid.get_grid()._states == level.final_grid._states:
		finish_level()


func load_level(id : int) -> void:
	current_level = id
	var level := levels[current_level]
	logic_grid.set_grid(level.initial_grid)
	stamp_select.set_tools(level.possible_tools)
	logic_grid.current_tool = level.possible_tools[0]
	
	logic_grid_container.ratio = float(level.initial_grid.num_cols) / (level.initial_grid.num_rows)
	
	level_title.text = level.name


func finish_level() -> void:
	if current_level < levels.size() - 1:
		load_level(current_level + 1)
