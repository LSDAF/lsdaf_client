class_name Player
extends Area2D

const ACTIONS = {ATTACK = "attack", DEATH = "death", IDLE = "death", MOVE = "move"}

var current_health: int
var action := ACTIONS.MOVE
var current_encounter: Mob = null


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_init_health()
	Stores.characteristics.health_property.value_changed.connect(_on_health_upgraded)

	%AnimatedSprite2D.play("move")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	%HealthBar.value = current_health


func _on_area_entered(area: Area2D) -> void:
	current_encounter = area
	action = ACTIONS.ATTACK
	%AnimatedSprite2D.play(action)


func _on_area_exited(_area: Area2D) -> void:
	current_encounter = null
	action = ACTIONS.MOVE
	%AnimatedSprite2D.play(action)


func _on_animated_sprite_2d_frame_changed() -> void:
	if %AnimatedSprite2D.animation == ACTIONS.ATTACK and %AnimatedSprite2D.frame == 1:
		if current_encounter != null:
			attack(current_encounter)


func _init_health() -> void:
	var health_value = (await Stores.characteristics.health_property.get_value()).current_value()
	current_health = health_value
	%HealthBar.max_value = health_value


func _on_health_upgraded(_old_value: Variant, new_value: Characteristic) -> void:
	%HealthBar.max_value = new_value.current_value()


func _get_player_damage() -> float:
	var attack := Services.player_stats.get_attack()
	var crit_chance := Services.player_stats.get_crit_chance()
	var crit_damage := Services.player_stats.get_crit_damage()

	var base_damage := attack.value * attack.multiplier

	var roll := randf()

	var is_critical_strike: bool = roll <= crit_chance.value * crit_chance.multiplier
	if is_critical_strike:
		return base_damage * (crit_damage.value * crit_damage.multiplier)

	return base_damage


func attack(target: Mob) -> void:
	target.take_damage(_get_player_damage())
