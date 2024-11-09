extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var attack_stat := Services.player_stats.get_attack()
	%AttackLabel.text = "Attack: {0} ({1}%)".format(
		[attack_stat.value, attack_stat.multiplier * 100]
	)

	var health_stat := Services.player_stats.get_health()
	%HealthLabel.text = "HEALTH: {0} ({1}%)".format(
		[health_stat.value, health_stat.multiplier * 100]
	)

	var crit_chance_stat := Services.player_stats.get_crit_chance()
	%CritChanceLabel.text = "Crit. Chance: {0}%".format([crit_chance_stat.value])

	var crit_damage_stat := Services.player_stats.get_crit_damage()
	%CritDamageLabel.text = "Crit. Damage: {0}%".format([crit_damage_stat.value])

	var resistance_stat := Services.player_stats.get_resistance()
	%ResistanceLabel.text = "Resistance: {0} ({1}%)".format(
		[resistance_stat.value, resistance_stat.multiplier * 100]
	)


func _on_close_button_pressed() -> void:
	queue_free()
