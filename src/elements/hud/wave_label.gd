extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.current_wave_update.connect(update_current_wave_updated)
	text = (
		"Wave: " + str(Services.stage.get_current_wave()) + "/" + str(Services.stage.get_max_wave())
	)


func update_current_wave_updated() -> void:
	text = (
		"Wave: " + str(Services.stage.get_current_wave()) + "/" + str(Services.stage.get_max_wave())
	)
