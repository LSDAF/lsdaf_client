extends GutTest

var sut: CharacteristicsService

var characteristics_data := preload("res://src/data/characteristics/characteristics_data.gd")

var characteristics_data_partial_double: Variant


func before_each() -> void:
	characteristics_data_partial_double = partial_double(characteristics_data).new()
	characteristics_data_partial_double.attack = Characteristic.new()
	characteristics_data_partial_double.crit_chance = Characteristic.new()
	characteristics_data_partial_double.crit_damage = Characteristic.new()
	characteristics_data_partial_double.health = Characteristic.new()
	characteristics_data_partial_double.resistance = Characteristic.new()

	sut = preload("res://src/services/characteristics/characteristics_service.gd").new(
		characteristics_data_partial_double
	)


func test_set_characteristics() -> void:
	# Arrange

	# Act
	sut._set_characteristics(100, 100, 100, 100, 100)

	# Assert
	assert_eq(characteristics_data_partial_double.attack._level, 100)
	assert_eq(characteristics_data_partial_double.crit_chance._level, 100)
	assert_eq(characteristics_data_partial_double.crit_damage._level, 100)
	assert_eq(characteristics_data_partial_double.health._level, 100)
	assert_eq(characteristics_data_partial_double.resistance._level, 100)
