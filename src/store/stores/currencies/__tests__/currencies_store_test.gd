extends GutTest

const CurrenciesStore := preload("res://src/store/stores/currencies/currencies_store.gd")

var sut: CurrenciesStore


func before_each() -> void:
	sut = CurrenciesStore.new()


func test_initial_values() -> void:
	# Assert
	assert_eq(sut.gold, 0)
	assert_eq(sut.diamond, 0)
	assert_eq(sut.emerald, 0)
	assert_eq(sut.amethyst, 0)


func test_set_currencies() -> void:
	# Act
	sut.set_currencies(100, 200, 300, 400)

	# Assert
	assert_eq(sut.gold, 100)
	assert_eq(sut.diamond, 200)
	assert_eq(sut.emerald, 300)
	assert_eq(sut.amethyst, 400)


func test_individual_currency_updates() -> void:
	# Act & Assert
	sut.gold = 100
	assert_eq(sut.gold, 100)

	sut.diamond = 200
	assert_eq(sut.diamond, 200)

	sut.emerald = 300
	assert_eq(sut.emerald, 300)

	sut.amethyst = 400
	assert_eq(sut.amethyst, 400)


func test_property_changed_signal() -> void:
	# Arrange
	watch_signals(sut)

	# Act
	sut.gold = 100

	# Assert
	assert_signal_emitted_with_parameters(sut, "property_changed", [&"gold"])
