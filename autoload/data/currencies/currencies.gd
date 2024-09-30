extends Node

class_name Currencies

var gold: Currency = Currency.new()
var diamond: Currency = Currency.new()
var amethyst: Currency = Currency.new()


# Init a custom start here (overrides loading of game save for nom)
func _ready() -> void:
	#gold.update_value(10000)
	return
