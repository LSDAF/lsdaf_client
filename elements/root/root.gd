extends Node

@export var game_main_scene: PackedScene
@export var launcher_scene: PackedScene

var game_main_scene_instance: GameMain
var launcher_scene_instance: Launcher


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_instanciate_launcher()

	pass  # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _instanciate_game() -> void:
	game_main_scene_instance = game_main_scene.instantiate()
	game_main_scene_instance.on_logout.connect(_on_logout)
	add_child(game_main_scene_instance)


func _instanciate_launcher() -> void:
	launcher_scene_instance = launcher_scene.instantiate()
	launcher_scene_instance.game_loaded.connect(_on_launcher_game_loaded)
	add_child(launcher_scene_instance)


func _on_logout() -> void:
	game_main_scene_instance.queue_free()
	_instanciate_launcher()


func _on_launcher_game_loaded() -> void:
	launcher_scene_instance.queue_free()
	_instanciate_game()
