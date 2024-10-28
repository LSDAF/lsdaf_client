class_name Toaster
extends CenterContainer

@export var toast_scene: PackedScene


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.toast.connect(add_toast)


func add_toast(message: String) -> void:
	var toast: Toast = toast_scene.instantiate()
	toast.set_message(message)
	add_child(toast)
