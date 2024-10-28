extends Button

@export var profile_menu: PackedScene


func _on_button_down() -> void:
	var menu := profile_menu.instantiate()
	owner.add_child(menu)
