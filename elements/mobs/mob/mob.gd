class_name Mob

extends Area2D

var BASE_SCALE_RATIO: float = 1
var BASE_SCALE: Vector2 = Vector2(BASE_SCALE_RATIO, BASE_SCALE_RATIO)
var BASE_DAMAGE_LABEL_DISTANCE: int = 150

@export var damage_taken_label_scene: PackedScene

signal mob_death

var max_health: int = 10
var health: int = 10
var gold_value: int = randi() % 10 + 1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.play("move")
	scale = BASE_SCALE

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var overlapping_areas := get_overlapping_areas()
	for overlapping_area in overlapping_areas:
		if (overlapping_area.position.x < position.x):
			return
			
	position.x -= 3
	
	$HealthBar.max_value = max_health

func take_damage(damage: int = 1) -> void:
	var damage_taken_label: DamageTakenLabel = damage_taken_label_scene.instantiate()
	damage_taken_label.text = str(damage)
	damage_taken_label.position.y -= BASE_DAMAGE_LABEL_DISTANCE * (1 / BASE_SCALE.y)
	
	add_child(damage_taken_label)
	
	health -= damage
	$HealthBar.value = health
	
	if (health <= 0):
		Currencies.gold.update_value(gold_value)
		mob_death.emit(self)
