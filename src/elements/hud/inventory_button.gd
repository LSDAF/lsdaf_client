extends Button

@export var inventory_menu: PackedScene


func _on_button_down() -> void:
	var menu := inventory_menu.instantiate()
	owner.add_child(menu)
