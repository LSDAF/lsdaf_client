class_name ToasterService


func toast(message: String) -> void:
	EventBus.toast.emit(message)
