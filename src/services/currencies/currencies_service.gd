class_name CurrenciesService

var _currency_data: CurrenciesData


func _init(currency_data: CurrenciesData) -> void:
	_currency_data = currency_data


# INFO: This function is only used for loading the game save
func _set_currencies(_gold: int, _diamond: int, _emerald: int, _amethyst: int) -> void:
	_currency_data.gold._value = _gold
	_currency_data.diamond._value = _diamond
	_currency_data.emerald._value = _emerald
	_currency_data.amethyst._value = _amethyst
