class_name Player

extends Area2D

const Actions = {ATTACK = 'attack', DEATH = 'death', IDLE = 'death', MOVE = 'move'}

var current_hp: int = Characteristics.hp.current_value()
var action := Actions.MOVE
var currentEncounter: Mob = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Characteristics.hp.upgraded.connect(_on_hp_upgraded)

	%AnimatedSprite2D.play("move")
	%HealthBar.max_value = Characteristics.hp.current_value()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	%HealthBar.value = current_hp

func _on_area_entered(area: Area2D) -> void:
	currentEncounter = area
	action = Actions.ATTACK
	%AnimatedSprite2D.play(action)

func _on_area_exited(area: Area2D) -> void:
	currentEncounter = null
	action = Actions.MOVE
	%AnimatedSprite2D.play(action)

func _on_animated_sprite_2d_frame_changed() -> void:
	if (%AnimatedSprite2D.animation == Actions.ATTACK and %AnimatedSprite2D.frame == 1):
		if (currentEncounter != null):
			attack(currentEncounter)
	pass # Replace with function body.

func _on_hp_upgraded() -> void:
	%HealthBar.max_value = Characteristics.hp.current_value()

func attack(target: Mob) -> void:
	target.take_damage(Characteristics.attack.current_value())
