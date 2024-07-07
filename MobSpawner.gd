extends Node2D

class_name MobSpawner

var main: Main

# Called when the node enters the scene tree for the first time.
func _ready():
	main = get_parent()
	spawn_mobs()
	
	Data.spawn_mobs.connect(_on_data_node_spawn_mobs)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func spawn_mobs():
	Data.current_mobs = main.generate_mobs()
	main.instanciate_mobs(Data.current_mobs)

func _on_data_node_spawn_mobs():
	spawn_mobs()
