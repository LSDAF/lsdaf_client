class_name CharacteristicsService

var _characteristics_data: CharacteristicsData


func _init(characteristics_data: CharacteristicsData) -> void:
	_characteristics_data = characteristics_data


# INFO: This function is only used for loading the game save
func _set_characteristics(
	attack: int, crit_chance: int, crit_damage: int, health: int, resistance: int
) -> void:
	_characteristics_data.attack._level = attack
	_characteristics_data.crit_chance._level = crit_chance
	_characteristics_data.crit_damage._level = crit_damage
	_characteristics_data.health._level = health
	_characteristics_data.resistance._level = resistance
