extends Control

signal on_logout


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%SettingsButton.on_logout.connect(_on_logout)


func _on_logout() -> void:
	on_logout.emit()
