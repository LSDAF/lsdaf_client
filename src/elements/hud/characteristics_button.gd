extends Button

@export var characteristics_menu: PackedScene


func _on_button_down() -> void:
	var menu := characteristics_menu.instantiate()
	owner.add_child(menu)
