extends Node

# Scripts
var api_client: ApiClient = preload("res://src/autoload/http/api_client/api_client.gd").new()
var api_routes: ApiRoutes = preload("res://src/autoload/http/api_routes/api_routes.gd").new()

# Scenes (CAUTION: The scenes need to be instanced in the _ready function)
var http_client: HttpClient = (
	preload("res://src/autoload/http/http_client/http_client.tscn").instantiate()
)


func _ready() -> void:
	add_child(http_client)
