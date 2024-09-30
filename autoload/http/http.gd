extends Node

# Scripts
var api_client: ApiClient = preload("res://autoload/http/api_client/api_client.gd").new()

# Scenes (CAUTION: The scenes need to be instanced in the _ready function)
var http_client: HttpClient = preload("res://autoload/http/http_client/http_client.tscn").instantiate()



func _ready() -> void:
	add_child(http_client)
