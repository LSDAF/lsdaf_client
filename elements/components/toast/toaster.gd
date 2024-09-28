extends CenterContainer

class_name Toaster

@export var toast_scene: PackedScene


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ToasterService.on_toast.connect(add_toast)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func add_toast(message: String) -> void:
	var toast: Toast = toast_scene.instantiate()
	toast.set_message(message)
	add_child(toast)
