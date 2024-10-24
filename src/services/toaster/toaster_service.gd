class_name ToasterService


static func toast(message: String) -> void:
	EventBus.toast.emit(message)
