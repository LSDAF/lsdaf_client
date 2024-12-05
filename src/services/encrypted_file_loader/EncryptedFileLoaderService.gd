class_name EncryptedFileLoaderService

# This service is responsible for loading encrypted files.
# It is used to load the game save files in case of offline savings.

const SECURITY_KEY: String = "SECURITY_KEY"


func load(path: String) -> Variant:
	var file_exists: bool = FileAccess.file_exists(path)
	if not file_exists:
		printerr("File does not exist (path: " + path + ")")
		return null

	var file: FileAccess = FileAccess.open_encrypted_with_pass(path, FileAccess.READ, SECURITY_KEY)
	if file == null:
		printerr("Error opening file (path: " + path + ")")
		return null

	var content: String = file.get_as_text()
	file.close()

	var data: Variant = JSON.parse_string(content)
	if data == null:
		printerr("Cannot parse %s as a json_string: (%s)" % [path, content])
		return null

	return data
