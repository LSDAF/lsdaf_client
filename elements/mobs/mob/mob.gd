class_name Mob

extends Area2D

var BASE_SCALE_RATIO: float = 1
var BASE_SCALE: Vector2 = Vector2(BASE_SCALE_RATIO, BASE_SCALE_RATIO)
var BASE_DAMAGE_LABEL_DISTANCE: int = 150
var BASE_DAMAGE_LABEL_X_OFFSET: int = 22

@export var damage_taken_label_scene: PackedScene
@export var scaler: MobScaler

signal mob_death

var max_health: int
var health: int
var gold_value: int = randi() % 10 + 1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	max_health = scaler.hp_from_difficulty(Difficulty.get_current_difficulty())
	health = max_health

	$AnimatedSprite2D.play("move")
	$HealthBar.max_value = max_health
	$HealthBar.value = health
	scale = BASE_SCALE


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var overlapping_areas := get_overlapping_areas()
	for overlapping_area in overlapping_areas:
		if overlapping_area.position.x < position.x:
			return

	position.x -= 3


func take_damage(damage: int = 1) -> void:
	var damage_taken_label: DamageTakenLabel = damage_taken_label_scene.instantiate()
	damage_taken_label.text = str(damage)

	damage_taken_label.position = position
	damage_taken_label.position.y -= BASE_DAMAGE_LABEL_DISTANCE * (1 / BASE_SCALE.y)
	damage_taken_label.position.x -= BASE_DAMAGE_LABEL_X_OFFSET

	get_parent().add_child(damage_taken_label)

	health -= damage
	$HealthBar.value = health

	if health <= 0:
		Data.currencies.gold.update_value(gold_value)
		mob_death.emit(self)
		Loot.try_loot_item()
