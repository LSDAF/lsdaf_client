extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.current_stage_update.connect(update_current_stage_updated)
	text = "Stage: " + str(Services.stage.get_current_stage())


func update_current_stage_updated() -> void:
	text = "Stage: " + str(Services.stage.get_current_stage())
