class_name SettingsMenu
extends Control

signal on_logout

@export var nickname_menu_scene: PackedScene


func _on_close_button_pressed() -> void:
	queue_free()


func _on_logout_button_pressed() -> void:
	on_logout.emit()


func _on_settings_button_pressed() -> void:
	var nickname_menu := nickname_menu_scene.instantiate()
	add_child(nickname_menu)
