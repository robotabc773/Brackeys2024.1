extends Control

const tool_stamp = preload("res://scripts/tools/tool_stamp.gd")
var stamp_dot : Tool = tool_stamp.new([Vector2i(0, 0)])
var stamp_pair : Tool = tool_stamp.new([Vector2i(0, 0), Vector2i(1, 0)])
var stamp_T : Tool = tool_stamp.new([Vector2i(0, 0), Vector2i(-1, 0), Vector2i(1, 0), Vector2i(0, 1)])
var stamp_J : Tool = tool_stamp.new([Vector2i(0, 0), Vector2i(-2, 0), Vector2i(-1, 0), Vector2i(0, 1)])
	
var levels : Array[Level] = [
	#Level.new("", [], Grid.from_json('')),
	Level.new("Left-click to stamp", [stamp_dot], Grid.from_json('{"num_cols":3,"num_rows":3,"states":[2,2,2,2,0,2,2,2,2]}')),
	Level.new("Fill it all in!", [stamp_dot], Grid.from_json('{"num_cols":4,"num_rows":3,"states":[2,2,2,2,2,0,0,2,2,2,2,2]}')),
	Level.new("Arrow keys to rotate", [stamp_pair], Grid.from_json('{"num_cols":9,"num_rows":4,"states":[2,2,2,2,2,2,2,2,2,2,0,0,0,0,0,0,0,2,2,0,0,0,0,0,0,0,2,2,2,2,2,2,2,2,2,2]}')),
	Level.new("Right-click to undo, R to restart", [stamp_pair], Grid.from_json('{"num_cols":8,"num_rows":6,"states":[2,2,2,2,2,2,2,2,2,0,0,0,0,0,0,2,2,2,0,0,2,0,2,2,2,0,2,0,0,0,0,2,2,0,0,0,0,0,0,2,2,2,2,2,2,2,2,2]}')),
	Level.new("Stamping flips tiles", [stamp_pair], Grid.from_json('{"num_cols":6,"num_rows":6,"states":[2,2,2,2,2,2,2,0,0,0,0,2,2,2,0,2,0,2,2,0,0,0,0,2,2,2,0,2,0,2,2,2,2,2,2,2]}')),
	Level.new("Multiple stamps!", [stamp_T, stamp_J], Grid.from_json('{"num_cols":4,"num_rows":4,"states":[0,0,0,0,2,0,2,0,2,0,0,0,0,0,0,2]}')),
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
