extends CenterContainer

var _new_nickname: String


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass  # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_error(response: Variant) -> void:
	Services.toaster_service.toast("Error when updating your nickname")


func _on_line_edit_text_changed(new_text: String) -> void:
	_new_nickname = new_text


func _on_button_pressed() -> void:
	var game_save_id := Services.game_save_service.get_game_save_id()
	var success := await Api.game_save.update_game_save_nickname(
		game_save_id, _new_nickname, _on_error
	)

	if success:
		queue_free()
