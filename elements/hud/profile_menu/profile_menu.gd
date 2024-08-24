extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var attack_stat: = PlayerStats.get_attack()
	%AttackLabel.text = "Attack: {0} ({1}%)".format([attack_stat.value, attack_stat.multiplier * 100])

	var hp_stat: = PlayerStats.get_hp()
	%HpLabel.text = "HP: {0} ({1}%)".format([hp_stat.value, hp_stat.multiplier * 100])
	
	var crit_chance_stat: = PlayerStats.get_crit_chance()
	%CritChanceLabel.text = "Crit. Chance: {0} ({1}%)".format([crit_chance_stat.value, crit_chance_stat.multiplier * 100])

	var crit_damage_stat: = PlayerStats.get_crit_damage()
	%CritDamageLabel.text = "Crit. Damage: {0} ({1}%)".format([crit_damage_stat.value, crit_damage_stat.multiplier * 100])
	
	var resistance_stat: = PlayerStats.get_resistance()
	%ResistanceLabel.text = "Resistance: {0} ({1}%)".format([resistance_stat.value, resistance_stat.multiplier * 100])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_close_button_pressed() -> void:
	queue_free()
