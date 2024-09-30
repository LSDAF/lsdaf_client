extends Node

# Scripts

# Scenes (CAUTION: The scenes need to be instanced in the _ready function)
var http_client: HttpClient = preload("res://autoload/http/http_client/http_client.tscn").instantiate()



func _ready() -> void:
	add_child(http_client)
