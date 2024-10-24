extends MarginContainer

signal on_login(email: String, password: String)

var _login_email: String
var _login_password: String

var _register_email: String
var _register_name: String
var _register_password: String

var _remember_me: bool


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_remember_me = UserLocalDataService.get_remember_me()
	_login_email = UserLocalDataService.get_email()
	_register_email = UserLocalDataService.get_email()
	_apply()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _apply() -> void:
	%LoginEmailLineEdit.text = _login_email
	%LoginPasswordLineEdit.text = _login_password
	%LoginRememberMeCheckBox.button_pressed = _remember_me

	%RegisterNameLineEdit.text = _register_name
	%RegisterEmailLineEdit.text = _register_email
	%RegisterPasswordLineEdit.text = _register_password
	%RegisterRememberMeCheckBox.button_pressed = _remember_me


func clear() -> void:
	_login_password = ""
	_register_name = ""
	_register_password = ""

	_apply()


func register(name: String, email: String, password: String) -> void:
	var registerResponse: RegisterResponseDto = await AuthApi.register(name, email, password, error)

	if registerResponse == null:
		return

	on_login.emit(email, password)


func error(response: Variant) -> void:
	ToasterService.toast("Error when registering")


func _on_login_button_pressed() -> void:
	UserLocalDataService.save_remember_me(_remember_me)

	if _remember_me:
		UserLocalDataService.save_email(_login_email)
	else:
		UserLocalDataService.save_email("")

	on_login.emit(_login_email, _login_password)


func _on_register_button_pressed() -> void:
	UserLocalDataService.save_remember_me(_remember_me)

	if _remember_me:
		UserLocalDataService.save_email(_login_email)
	else:
		UserLocalDataService.save_email("")

	register(_register_name, _register_email, _register_password)


func _on_login_email_line_edit_text_changed(new_text: String) -> void:
	_login_email = new_text


func _on_login_password_line_edit_text_changed(new_text: String) -> void:
	_login_password = new_text


func _on_register_name_line_edit_text_changed(new_text: String) -> void:
	_register_name = new_text


func _on_register_email_line_edit_text_changed(new_text: String) -> void:
	_register_email = new_text


func _on_register_password_line_edit_text_changed(new_text: String) -> void:
	_register_password = new_text


func _on_go_to_register_button_pressed() -> void:
	clear()

	%LoginVBoxContainer.hide()
	%RegisterVBoxContainer.show()


func _on_go_to_login_button_pressed() -> void:
	clear()

	%RegisterVBoxContainer.hide()
	%LoginVBoxContainer.show()


func _on_remember_me_check_box_toggled(toggled_on: bool) -> void:
	_remember_me = toggled_on
