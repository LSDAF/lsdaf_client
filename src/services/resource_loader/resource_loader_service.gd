class_name ResourceLoaderService


func exists(path: String, type_hint: String = "") -> bool:
	return ResourceLoader.exists(path, type_hint)


func load(path: String, type_hint: String = "") -> Resource:
	return ResourceLoader.load(path, type_hint)
