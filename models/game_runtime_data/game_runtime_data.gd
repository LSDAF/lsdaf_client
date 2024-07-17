class_name GameRuntimeData
extends Resource

signal game_node_position_changed(position: Vector2)
signal game_node_scale_changed(size: Vector2)

@export var game_node_position: Vector2
@export var game_node_scale: Vector2
	
func set_game_node_position(position: Vector2):
	game_node_position = position
	game_node_position_changed.emit(position)

func set_game_node_scale(scale: Vector2):
	game_node_scale = scale
	game_node_scale_changed.emit(scale)
	
