extends Button

signal on_logout

@export var settings_menu: PackedScene


func _on_logout() -> void:
	on_logout.emit()


func _on_button_down() -> void:
	var menu: SettingsMenu = settings_menu.instantiate()
	menu.on_logout.connect(_on_logout)
	owner.add_child(menu)
