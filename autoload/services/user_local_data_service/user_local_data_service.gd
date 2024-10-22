extends Node

class_name UserLocalDataService


const USER_DATA_PATH = "user://user_data.res"


func create_new_user_data() -> void:
	Data.user_local_data._user_data = UserData.new()
	save_to_device()


func load() -> UserData:
	if ResourceLoader.exists(USER_DATA_PATH):
		var user_data := ResourceLoader.load(USER_DATA_PATH)
		if user_data is UserData:  # Check that the data is valid
			Data.user_local_data._user_data = user_data
			return Data.user_local_data._user_data

	# If error on loading of the data, generate a new one
	create_new_user_data()

	return Data.user_local_data._user_data


func relog_user() -> bool:
	if Data.user_local_data._user_data.refresh_token == "" or Data.user_local_data._user_data.email == "":
		return false

	var refreshLoginResponse := await Api.auth.refresh_login(
		Data.user_local_data._user_data.email, Data.user_local_data._user_data.refresh_token, _on_relog_failed
	)

	if refreshLoginResponse == null:
		return false

	Services.user_local_data.save_access_token(refreshLoginResponse.access_token)
	Services.user_local_data.save_refresh_token(refreshLoginResponse.refresh_token)
	Services.user_local_data.save_email(refreshLoginResponse.user_info.email)

	return true


func save_to_device() -> Error:
	return ResourceSaver.save(Data.user_local_data._user_data, USER_DATA_PATH)


func get_access_token() -> String:
	return Data.user_local_data._user_data.access_token


func get_refresh_token() -> String:
	return Data.user_local_data._user_data.refresh_token


func save_access_token(access_token: String) -> bool:
	Data.user_local_data._user_data.access_token = access_token

	var result: Error = save_to_device()
	return result == Error.OK


func save_refresh_token(refresh_token: String) -> bool:
	Data.user_local_data._user_data.refresh_token = refresh_token

	var result: Error = save_to_device()
	return result == Error.OK


func save_email(email: String) -> bool:
	Data.user_local_data._user_data.email = email

	var result: Error = save_to_device()
	return result == Error.OK


func _on_relog_failed(response: Variant) -> void:
	Services.toaster.toast("Error when relogging")
