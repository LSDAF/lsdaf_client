extends Node

class_name Currencies

var gold: Currency = Currency.new()
var diamond: Currency = Currency.new()
var emerald: Currency = Currency.new()
var amethyst: Currency = Currency.new()


func _ready() -> void:
	return


# INFO: This function is only used for loading the game save
func _set_currencies(_gold: int, _diamond: int, _emerald: int, _amethyst: int) -> void:
	gold.update_value(_gold)
	diamond.update_value(_diamond)
	emerald.update_value(_emerald)
	amethyst.update_value(_amethyst)
