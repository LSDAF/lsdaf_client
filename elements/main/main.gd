extends Node

@export var game_main_scene: PackedScene
@export var launcher_scene: PackedScene

var game_main_scene_instance: GameMain
var launcher_scene_instance: Launcher

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	launcher_scene_instance = launcher_scene.instantiate()
	launcher_scene_instance.game_loaded.connect(_on_launcher_game_loaded)
	add_child(launcher_scene_instance)
	pass  # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_logout() -> void:
	game_main_scene_instance.queue_free()


func _on_launcher_game_loaded() -> void:
	launcher_scene_instance.queue_free()
	game_main_scene_instance = game_main_scene.instantiate()
	add_child(game_main_scene_instance)
