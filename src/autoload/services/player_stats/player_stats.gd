extends Node

class_name PlayerStats


#####   Attack   #####
func _get_attack_multiplier() -> float:
	var equipped_items_total_multiplier := 1.0

	for equipped_items_index in Services.inventory.get_equipped_items_index():
		var item := Services.inventory.get_item_at_index(equipped_items_index)
		equipped_items_total_multiplier += (
			item.total_stat_value(ItemStatistics.ItemStatistics.ATTACK_MULT) / 100.0
		)

	return equipped_items_total_multiplier


func _get_attack_value() -> float:
	var equipped_items_total_value := 0.0

	for equipped_items_index in Services.inventory.get_equipped_items_index():
		var item := Services.inventory.get_item_at_index(equipped_items_index)
		equipped_items_total_value += item.total_stat_value(
			ItemStatistics.ItemStatistics.ATTACK_ADD
		)

	return equipped_items_total_value + Data.characteristics.attack.current_value()


func get_attack() -> PlayerStat:
	var stat := PlayerStat.new()

	stat.value = _get_attack_value()
	stat.multiplier = _get_attack_multiplier()

	return stat


#####   Crit. Chance   #####
func _get_crit_chance_value() -> float:
	var equipped_items_total_value := 0.0

	for equipped_items_index in Services.inventory.get_equipped_items_index():
		var item := Services.inventory.get_item_at_index(equipped_items_index)
		equipped_items_total_value += item.total_stat_value(
			ItemStatistics.ItemStatistics.CRIT_CHANCE
		)

	return equipped_items_total_value + Data.characteristics.crit_chance.current_value()


func get_crit_chance() -> PlayerStat:
	var stat := PlayerStat.new()

	stat.value = _get_crit_chance_value()
	stat.multiplier = 1

	return stat


#####   Crit. Damage   #####
func _get_crit_damage_value() -> float:
	var equipped_items_total_value := 0.0

	for equipped_items_index in Services.inventory.get_equipped_items_index():
		var item := Services.inventory.get_item_at_index(equipped_items_index)
		equipped_items_total_value += item.total_stat_value(
			ItemStatistics.ItemStatistics.CRIT_DAMAGE
		)

	return equipped_items_total_value + Data.characteristics.crit_damage.current_value()


func get_crit_damage() -> PlayerStat:
	var stat := PlayerStat.new()

	stat.value = _get_crit_damage_value()
	stat.multiplier = 1

	return stat


#####   HP   #####
func _get_hp_multiplier() -> float:
	var equipped_items_total_multiplier := 1.0

	for equipped_items_index in Services.inventory.get_equipped_items_index():
		var item := Services.inventory.get_item_at_index(equipped_items_index)
		equipped_items_total_multiplier += (
			item.total_stat_value(ItemStatistics.ItemStatistics.HP_MULT) / 100.0
		)

	return equipped_items_total_multiplier


func _get_hp_value() -> float:
	var equipped_items_total_value := 0.0

	for equipped_items_index in Services.inventory.get_equipped_items_index():
		var item := Services.inventory.get_item_at_index(equipped_items_index)
		equipped_items_total_value += item.total_stat_value(ItemStatistics.ItemStatistics.HP_ADD)

	return equipped_items_total_value + Data.characteristics.hp.current_value()


func get_hp() -> PlayerStat:
	var stat := PlayerStat.new()

	stat.value = _get_hp_value()
	stat.multiplier = _get_hp_multiplier()

	return stat


#####   Resistance   #####
func _get_resistance_multiplier() -> float:
	var equipped_items_total_multiplier := 1.0

	for equipped_items_index in Services.inventory.get_equipped_items_index():
		var item := Services.inventory.get_item_at_index(equipped_items_index)
		equipped_items_total_multiplier += (
			item.total_stat_value(ItemStatistics.ItemStatistics.RESISTANCE_MULT) / 100.0
		)

	return equipped_items_total_multiplier


func _get_resistance_value() -> float:
	var equipped_items_total_value := 0.0

	for equipped_items_index in Services.inventory.get_equipped_items_index():
		var item := Services.inventory.get_item_at_index(equipped_items_index)
		equipped_items_total_value += item.total_stat_value(
			ItemStatistics.ItemStatistics.RESISTANCE_ADD
		)

	return equipped_items_total_value + Data.characteristics.resistance.current_value()


func get_resistance() -> PlayerStat:
	var stat := PlayerStat.new()

	stat.value = _get_resistance_value()
	stat.multiplier = _get_resistance_multiplier()

	return stat
