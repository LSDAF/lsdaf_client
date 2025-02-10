class_name PlayerStatsService
extends Node

var _inventory_service: InventoryService


func _init(inventory_service: InventoryService) -> void:
	_inventory_service = inventory_service


##### Attack #####
func _get_attack_multiplier() -> float:
	var equipped_items_total_multiplier := 1.0

	for equipped_items_client_id in _inventory_service.get_equipped_items_client_id():
		var item := _inventory_service.get_item_from_client_id(equipped_items_client_id)
		equipped_items_total_multiplier += (
			item.total_stat_value(ItemStatistics.ItemStatistics.ATTACK_MULT) / 100.0
		)

	return equipped_items_total_multiplier


func _get_attack_value() -> float:
	var equipped_items_total_value := 0.0

	for equipped_items_client_id in _inventory_service.get_equipped_items_client_id():
		var item := _inventory_service.get_item_from_client_id(equipped_items_client_id)
		equipped_items_total_value += item.total_stat_value(
			ItemStatistics.ItemStatistics.ATTACK_ADD
		)

	return (
		equipped_items_total_value
		+ (await Stores.characteristics.attack_property.get_value()).current_value()
	)


func get_attack() -> PlayerStat:
	var stat := PlayerStat.new()

	stat.value = await _get_attack_value()
	stat.multiplier = _get_attack_multiplier()

	return stat


#####   Crit. Chance   #####
func _get_crit_chance_value() -> float:
	var equipped_items_total_value := 0.0

	for equipped_items_client_id in _inventory_service.get_equipped_items_client_id():
		var item := _inventory_service.get_item_from_client_id(equipped_items_client_id)
		equipped_items_total_value += item.total_stat_value(
			ItemStatistics.ItemStatistics.CRIT_CHANCE
		)

	return (
		equipped_items_total_value
		+ (await Stores.characteristics.crit_chance_property.get_value()).current_value()
	)


func get_crit_chance() -> PlayerStat:
	var stat := PlayerStat.new()

	stat.value = await _get_crit_chance_value()
	stat.multiplier = 1

	return stat


#####   Crit. Damage   #####
func _get_crit_damage_value() -> float:
	var equipped_items_total_value := 0.0

	for equipped_items_client_id in _inventory_service.get_equipped_items_client_id():
		var item := _inventory_service.get_item_from_client_id(equipped_items_client_id)
		equipped_items_total_value += item.total_stat_value(
			ItemStatistics.ItemStatistics.CRIT_DAMAGE
		)

	return (
		equipped_items_total_value
		+ (await Stores.characteristics.crit_damage_property.get_value()).current_value()
	)


func get_crit_damage() -> PlayerStat:
	var stat := PlayerStat.new()

	stat.value = await _get_crit_damage_value()
	stat.multiplier = 1

	return stat


#####   Health   #####
func _get_health_multiplier() -> float:
	var equipped_items_total_multiplier := 1.0

	for equipped_items_client_id in _inventory_service.get_equipped_items_client_id():
		var item := _inventory_service.get_item_from_client_id(equipped_items_client_id)
		equipped_items_total_multiplier += (
			item.total_stat_value(ItemStatistics.ItemStatistics.HEALTH_MULT) / 100.0
		)

	return equipped_items_total_multiplier


func _get_health_value() -> float:
	var equipped_items_total_value := 0.0

	for equipped_items_client_id in _inventory_service.get_equipped_items_client_id():
		var item := _inventory_service.get_item_from_client_id(equipped_items_client_id)
		equipped_items_total_value += item.total_stat_value(
			ItemStatistics.ItemStatistics.HEALTH_ADD
		)

	return (
		equipped_items_total_value
		+ (await Stores.characteristics.health_property.get_value()).current_value()
	)


func get_health() -> PlayerStat:
	var stat := PlayerStat.new()

	stat.value = await _get_health_value()
	stat.multiplier = _get_health_multiplier()

	return stat


#####   Resistance   #####
func _get_resistance_multiplier() -> float:
	var equipped_items_total_multiplier := 1.0

	for equipped_items_client_id in _inventory_service.get_equipped_items_client_id():
		var item := _inventory_service.get_item_from_client_id(equipped_items_client_id)
		equipped_items_total_multiplier += (
			item.total_stat_value(ItemStatistics.ItemStatistics.RESISTANCE_MULT) / 100.0
		)

	return equipped_items_total_multiplier


func _get_resistance_value() -> float:
	var equipped_items_total_value := 0.0

	for equipped_items_client_id in _inventory_service.get_equipped_items_client_id():
		var item := _inventory_service.get_item_from_client_id(equipped_items_client_id)
		equipped_items_total_value += item.total_stat_value(
			ItemStatistics.ItemStatistics.RESISTANCE_ADD
		)

	return (
		equipped_items_total_value
		+ (await Stores.characteristics.resistance_property.get_value()).current_value()
	)


func get_resistance() -> PlayerStat:
	var stat := PlayerStat.new()

	stat.value = await _get_resistance_value()
	stat.multiplier = _get_resistance_multiplier()

	return stat
