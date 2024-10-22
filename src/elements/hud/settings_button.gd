extends Button

@export var settings_menu: PackedScene

signal on_logout


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass  # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_logout() -> void:
	on_logout.emit()


func _on_button_down() -> void:
	var menu: SettingsMenu = settings_menu.instantiate()
	menu.on_logout.connect(_on_logout)
	owner.add_child(menu)
