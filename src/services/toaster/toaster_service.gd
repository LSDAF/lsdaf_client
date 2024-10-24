class_name ToasterService

signal on_toast(message: String)


static func toast(message: String) -> void:
	on_toast.emit(message)
