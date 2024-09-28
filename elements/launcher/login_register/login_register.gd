extends MarginContainer

signal login_pressed(email: String, password: String)

var _login_email: String
var _login_password: String


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass  # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_login_button_pressed() -> void:
	login_pressed.emit(_login_email, _login_password)


func _on_login_email_line_edit_text_changed(new_text: String) -> void:
	_login_email = new_text


func _on_login_password_line_edit_text_changed(new_text: String) -> void:
	_login_password = new_text
