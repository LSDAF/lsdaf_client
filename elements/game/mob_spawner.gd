extends Marker2D

@export var current_mobs: Array[Mob] = []
@export var game_runtime_data: GameRuntimeData
@export var mob_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_mobs()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func generate_mobs():
	var mobs: Array[Mob] = []
	
	for i in range(10):
		var mob = mob_scene.instantiate()
		
		mob.position = position
		mob.position.x += i * 100 * game_runtime_data.game_node_scale.x
		mob.rotation = TAU
		
		mob.mob_death.connect(on_mob_death)
		
		mobs.push_back(mob)
		
	return mobs

func instanciate_mobs(mobs: Array[Mob]):
	for i in range(mobs.size()):
		owner.call_deferred('add_child', mobs[i])

func on_mob_death(mob: Mob):
	mob.queue_free()
	var mob_index = current_mobs.find(mob)
	current_mobs.remove_at(mob_index)
	
	if (current_mobs.size() < 1):
		Stage.beat_current_stage()
		spawn_mobs()

func spawn_mobs():
	current_mobs = generate_mobs()
	instanciate_mobs(current_mobs)
