extends Node2D

@export var game_runtime_data: GameRuntimeData

# Called when the node enters the scene tree for the first time.
func _ready():
	game_runtime_data.game_node_position_changed.connect(update_position)
	game_runtime_data.game_node_scale_changed.connect(update_scale)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func update_position(new_position: Vector2):
	position = new_position
	
func update_scale(new_scale: Vector2):
	scale = new_scale
