class_name GameRuntimeData
extends Resource

signal game_node_position_changed(position: Vector2)
signal game_node_size_changed(size: Vector2)

@export var game_node_position: Vector2
@export var game_node_size: Vector2
	
func set_game_node_position(position: Vector2):
	game_node_position = position
	game_node_position_changed.emit(position)

func set_game_node_size(size: Vector2):
	game_node_size = size
	game_node_size_changed.emit(size)
	
