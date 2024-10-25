extends GutTest


func test_set_currencies() -> void:
	# Arrange

	# Act
	CurrenciesService._set_currencies(100.0, 100.0, 100.0, 100.0)

	# Assert
	assert_eq(Data.currencies.gold.get_value(), 100.0)
	assert_eq(Data.currencies.diamond.get_value(), 100.0)
	assert_eq(Data.currencies.emerald.get_value(), 100.0)
	assert_eq(Data.currencies.amethyst.get_value(), 100.0)
