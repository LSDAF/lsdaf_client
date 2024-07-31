extends Node

var gold: Currency = Currency.new()
var diamond: Currency = Currency.new()


# DEFAULT FOR DEV
func _ready() -> void:
	gold.update_value(1000)
