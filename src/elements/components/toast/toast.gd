class_name Toast
extends NinePatchRect


func set_message(message: String) -> void:
	%MessageLabel.text = message


func _on_timer_timeout() -> void:
	queue_free()
