extends Node

class_name Currencies

var gold: Currency = Currency.new()
var diamond: Currency = Currency.new()
var emerald: Currency = Currency.new()
var amethyst: Currency = Currency.new()


func _ready() -> void:
	return


func load_currencies(_gold: int, _diamonds: int, _emeralds: int, _amethysts: int) -> void:
	gold.update_value(_gold)
	diamond.update_value(_diamonds)
	emerald.update_value(_emeralds)
	amethyst.update_value(_amethysts)
