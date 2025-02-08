extends GutTest

const CharacteristicsStore := preload(
	"res://src/store/stores/characteristics/characteristics_store.gd"
)

var sut: CharacteristicsStore


func before_each() -> void:
	sut = CharacteristicsStore.new()


func test_initial_values() -> void:
	# Assert
	assert_eq(sut.attack, 0)
	assert_eq(sut.crit_chance, 0)
	assert_eq(sut.crit_damage, 0)
	assert_eq(sut.health, 0)
	assert_eq(sut.resistance, 0)


func test_set_characteristics() -> void:
	# Act
	sut.set_characteristics(10, 20, 30, 40, 50)

	# Assert
	assert_eq(sut.attack, 10)
	assert_eq(sut.crit_chance, 20)
	assert_eq(sut.crit_damage, 30)
	assert_eq(sut.health, 40)
	assert_eq(sut.resistance, 50)


func test_individual_characteristic_updates() -> void:
	# Act & Assert
	sut.attack = 10
	assert_eq(sut.attack, 10)

	sut.crit_chance = 20
	assert_eq(sut.crit_chance, 20)

	sut.crit_damage = 30
	assert_eq(sut.crit_damage, 30)

	sut.health = 40
	assert_eq(sut.health, 40)

	sut.resistance = 50
	assert_eq(sut.resistance, 50)


func test_property_changed_signal() -> void:
	# Arrange
	watch_signals(sut)

	# Act
	sut.attack = 10

	# Assert
	assert_signal_emitted_with_parameters(sut, "property_changed", [&"attack"])
