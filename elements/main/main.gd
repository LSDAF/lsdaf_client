extends Node

@export var game_main_scene: PackedScene


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass  # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_launcher_game_loaded() -> void:
	%Launcher.queue_free()
	add_child(game_main_scene.instantiate())
