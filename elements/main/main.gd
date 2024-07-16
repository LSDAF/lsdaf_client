extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	HttpClient.login_user("toto@toto.fr", "k127F978")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
