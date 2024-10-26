extends GutTest

var sut: CurrenciesService

var currency_data := preload("res://src/data/currencies/currencies_data.gd")

var currency_data_partial_double: Variant

func before_each() -> void:
	currency_data_partial_double = partial_double(currency_data).new()
	currency_data_partial_double.gold = Currency.new()
	currency_data_partial_double.diamond = Currency.new()
	currency_data_partial_double.emerald = Currency.new()
	currency_data_partial_double.amethyst = Currency.new()

	sut = preload("res://src/services/currencies/currencies_service.gd").new(currency_data_partial_double)

func test_set_currencies() -> void:
	# Arrange

	# Act
	sut._set_currencies(100, 100, 100, 100)

	# Assert
	assert_eq(currency_data_partial_double.gold.get_value(), 100)
	assert_eq(currency_data_partial_double.diamond.get_value(), 100)
	assert_eq(currency_data_partial_double.emerald.get_value(), 100)
	assert_eq(currency_data_partial_double.amethyst.get_value(), 100)
