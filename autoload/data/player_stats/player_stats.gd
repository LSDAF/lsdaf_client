extends Node


#####   Attack   #####
func _get_attack_value() -> float:
	return Characteristics.attack.current_value()


func get_attack() -> PlayerStat:
	var stat := PlayerStat.new()

	stat.value = _get_attack_value()
	stat.multiplier = 1

	return stat


#####   Crit. Chance   #####
func _get_crit_chance_value() -> float:
	return Characteristics.crit_chance.current_value()


func get_crit_chance() -> PlayerStat:
	var stat := PlayerStat.new()

	stat.value = _get_crit_chance_value()
	stat.multiplier = 1

	return stat


#####   Crit. Damage   #####
func _get_crit_damage_value() -> float:
	return Characteristics.crit_damage.current_value()


func get_crit_damage() -> PlayerStat:
	var stat := PlayerStat.new()

	stat.value = _get_crit_damage_value()
	stat.multiplier = 1

	return stat


#####   HP   #####
func _get_hp_value() -> float:
	return Characteristics.hp.current_value()


func get_hp() -> PlayerStat:
	var stat := PlayerStat.new()

	stat.value = _get_hp_value()
	stat.multiplier = 1

	return stat


#####   Resistance   #####
func _get_resistance_value() -> float:
	return Characteristics.resistance.current_value()


func get_resistance() -> PlayerStat:
	var stat := PlayerStat.new()

	stat.value = _get_resistance_value()
	stat.multiplier = 1

	return stat
