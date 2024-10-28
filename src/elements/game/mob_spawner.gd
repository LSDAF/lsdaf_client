extends Marker2D

const WAVE_SIZE := 10

@export var current_mobs: Array[Mob] = []
@export var mob_scene: PackedScene
@export var boss_scene: PackedScene


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_mobs()


func generate_boss() -> Array[Mob]:
	var boss: Boss = boss_scene.instantiate()
	boss.position = position
	boss.position.x += 100
	boss.rotation = TAU

	boss.mob_death.connect(on_mob_death)

	return [boss]


func generate_mobs() -> Array[Mob]:
	var mobs: Array[Mob] = []

	for i in range(WAVE_SIZE):
		var mob := mob_scene.instantiate()

		mob.position = position
		mob.position.x += i * 100
		mob.rotation = TAU

		mob.mob_death.connect(on_mob_death)

		mobs.push_back(mob)

	return mobs


func instanciate_mobs(mobs: Array[Mob]) -> void:
	for i in range(mobs.size()):
		owner.call_deferred("add_child", mobs[i])


func on_mob_death(mob: Mob) -> void:
	mob.queue_free()
	Services.current_quest.on_mob_death()

	var mob_index := current_mobs.find(mob)
	current_mobs.remove_at(mob_index)

	if current_mobs.size() < 1:
		Services.stage.beat_current_wave()
		if Services.stage.is_boss_wave():
			spawn_boss()
		else:
			spawn_mobs()


func spawn_mobs() -> void:
	current_mobs = generate_mobs()
	instanciate_mobs(current_mobs)


func spawn_boss() -> void:
	current_mobs = generate_boss()
	instanciate_mobs(current_mobs)
