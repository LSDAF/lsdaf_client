class_name EncryptedFileSaverService

const SECURITY_KEY: String = "SECURITY_KEY"

# This service is responsible for saving encrypted files.
# It is used to save the game save files in case of offline savings.


func save(path: String, data: Variant) -> void:
	var file: FileAccess = FileAccess.open_encrypted_with_pass(path, FileAccess.WRITE, SECURITY_KEY)
	if file == null:
		printerr(FileAccess.get_open_error())
		return

	var content: String = JSON.stringify(data)
	file.store_string(content)
	file.close()
