class_name PlayerStatsService

var _characteristics_data: CharacteristicsData
var _inventory_service: InventoryService


func _init(characteristics_data: CharacteristicsData, inventory_service: InventoryService) -> void:
	_characteristics_data = characteristics_data
	_inventory_service = inventory_service


##### Attack #####
func _get_attack_multiplier() -> float:
	var equipped_items_total_multiplier := 1.0

	for equipped_items_index in _inventory_service.get_equipped_items_index():
		var item := _inventory_service.get_item_at_index(equipped_items_index)
		equipped_items_total_multiplier += (
			item.total_stat_value(ItemStatistics.ItemStatistics.ATTACK_MULT) / 100.0
		)

	return equipped_items_total_multiplier


func _get_attack_value() -> float:
	var equipped_items_total_value := 0.0

	for equipped_items_index in _inventory_service.get_equipped_items_index():
		var item := _inventory_service.get_item_at_index(equipped_items_index)
		equipped_items_total_value += item.total_stat_value(
			ItemStatistics.ItemStatistics.ATTACK_ADD
		)

	return equipped_items_total_value + _characteristics_data.attack.current_value()


func get_attack() -> PlayerStat:
	var stat := PlayerStat.new()

	stat.value = _get_attack_value()
	stat.multiplier = _get_attack_multiplier()

	return stat


#####   Crit. Chance   #####
func _get_crit_chance_value() -> float:
	var equipped_items_total_value := 0.0

	for equipped_items_index in _inventory_service.get_equipped_items_index():
		var item := _inventory_service.get_item_at_index(equipped_items_index)
		equipped_items_total_value += item.total_stat_value(
			ItemStatistics.ItemStatistics.CRIT_CHANCE
		)

	return equipped_items_total_value + _characteristics_data.crit_chance.current_value()


func get_crit_chance() -> PlayerStat:
	var stat := PlayerStat.new()

	stat.value = _get_crit_chance_value()
	stat.multiplier = 1

	return stat


#####   Crit. Damage   #####
func _get_crit_damage_value() -> float:
	var equipped_items_total_value := 0.0

	for equipped_items_index in _inventory_service.get_equipped_items_index():
		var item := _inventory_service.get_item_at_index(equipped_items_index)
		equipped_items_total_value += item.total_stat_value(
			ItemStatistics.ItemStatistics.CRIT_DAMAGE
		)

	return equipped_items_total_value + _characteristics_data.crit_damage.current_value()


func get_crit_damage() -> PlayerStat:
	var stat := PlayerStat.new()

	stat.value = _get_crit_damage_value()
	stat.multiplier = 1

	return stat


#####   Health   #####
func _get_health_multiplier() -> float:
	var equipped_items_total_multiplier := 1.0

	for equipped_items_index in _inventory_service.get_equipped_items_index():
		var item := _inventory_service.get_item_at_index(equipped_items_index)
		equipped_items_total_multiplier += (
			item.total_stat_value(ItemStatistics.ItemStatistics.HEALTH_MULT) / 100.0
		)

	return equipped_items_total_multiplier


func _get_health_value() -> float:
	var equipped_items_total_value := 0.0

	for equipped_items_index in _inventory_service.get_equipped_items_index():
		var item := _inventory_service.get_item_at_index(equipped_items_index)
		equipped_items_total_value += item.total_stat_value(
			ItemStatistics.ItemStatistics.HEALTH_ADD
		)

	return equipped_items_total_value + _characteristics_data.health.current_value()


func get_health() -> PlayerStat:
	var stat := PlayerStat.new()

	stat.value = _get_health_value()
	stat.multiplier = _get_health_multiplier()

	return stat


#####   Resistance   #####
func _get_resistance_multiplier() -> float:
	var equipped_items_total_multiplier := 1.0

	for equipped_items_index in _inventory_service.get_equipped_items_index():
		var item := _inventory_service.get_item_at_index(equipped_items_index)
		equipped_items_total_multiplier += (
			item.total_stat_value(ItemStatistics.ItemStatistics.RESISTANCE_MULT) / 100.0
		)

	return equipped_items_total_multiplier


func _get_resistance_value() -> float:
	var equipped_items_total_value := 0.0

	for equipped_items_index in _inventory_service.get_equipped_items_index():
		var item := _inventory_service.get_item_at_index(equipped_items_index)
		equipped_items_total_value += item.total_stat_value(
			ItemStatistics.ItemStatistics.RESISTANCE_ADD
		)

	return equipped_items_total_value + _characteristics_data.resistance.current_value()


func get_resistance() -> PlayerStat:
	var stat := PlayerStat.new()

	stat.value = _get_resistance_value()
	stat.multiplier = _get_resistance_multiplier()

	return stat
