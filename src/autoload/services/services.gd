extends Node

# Scripts CAUTION: You should not use scripts here, make a class with only static functions

# Scenes (CAUTION: The scenes need to be instanced in the _ready function)
var items_service: ItemsService = (
	preload("res://src/autoload/services/items/items_service.tscn").instantiate()
)


func _ready() -> void:
	add_child(items_service)
