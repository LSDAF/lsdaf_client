extends Node

class_name CurrenciesService


# INFO: This function is only used for loading the game save
func _set_currencies(_gold: int, _diamond: int, _emerald: int, _amethyst: int) -> void:
	Data.currencies.gold.update_value(_gold)
	Data.currencies.diamond.update_value(_diamond)
	Data.currencies.emerald.update_value(_emerald)
	Data.currencies.amethyst.update_value(_amethyst)
