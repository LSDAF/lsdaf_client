extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var attack_stat := PlayerStatsService.get_attack()
	%AttackLabel.text = "Attack: {0} ({1}%)".format(
		[attack_stat.value, attack_stat.multiplier * 100]
	)

	var hp_stat := PlayerStatsService.get_hp()
	%HpLabel.text = "HP: {0} ({1}%)".format([hp_stat.value, hp_stat.multiplier * 100])

	var crit_chance_stat := PlayerStatsService.get_crit_chance()
	%CritChanceLabel.text = "Crit. Chance: {0}%".format([crit_chance_stat.value])

	var crit_damage_stat := PlayerStatsService.get_crit_damage()
	%CritDamageLabel.text = "Crit. Damage: {0}%".format([crit_damage_stat.value])

	var resistance_stat := PlayerStatsService.get_resistance()
	%ResistanceLabel.text = "Resistance: {0} ({1}%)".format(
		[resistance_stat.value, resistance_stat.multiplier * 100]
	)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_close_button_pressed() -> void:
	queue_free()
