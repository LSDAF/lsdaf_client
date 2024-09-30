extends Control

class_name SettingsMenu

signal on_logout

@export var nickname_menu_scene: PackedScene


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_close_button_pressed() -> void:
	queue_free()


func _on_logout_button_pressed() -> void:
	on_logout.emit()
	pass  # Replace with function body.


func _on_settings_button_pressed() -> void:
	var nickname_menu := nickname_menu_scene.instantiate()
	add_child(nickname_menu)
