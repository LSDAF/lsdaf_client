extends Node

var gold: Currency = Currency.new()
var diamond: Currency = Currency.new()
var amethyst: Currency = Currency.new()


# DEFAULT FOR DEV
func _ready() -> void:
	gold.update_value(10000)
