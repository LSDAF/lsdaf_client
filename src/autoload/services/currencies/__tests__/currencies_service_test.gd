# GdUnit generated TestSuite
class_name CurrenciesServiceTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://src/autoload/services/currencies/currencies_service.gd'


func test__set_currencies() -> void:
	# Arrange
	
	# Act
	Services.currencies._set_currencies(1, 2, 3, 4)
	
	# Assert
	assert_int(Data.currencies.gold.get_value()).is_equal(1)
	assert_int(Data.currencies.diamond.get_value()).is_equal(2)
	assert_int(Data.currencies.emerald.get_value()).is_equal(3)
	assert_int(Data.currencies.amethyst.get_value()).is_equal(4)
