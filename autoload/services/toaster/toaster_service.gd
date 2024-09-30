extends Node

class_name ToasterService

signal on_toast(message: String)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass  # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func toast(message: String) -> void:
	on_toast.emit(message)
