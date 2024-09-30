extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Data.stage.current_stage_updated.connect(update_current_stage_updated)
	text = "Stage: " + str(Data.stage.get_current_stage())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func update_current_stage_updated(new_stage: int) -> void:
	text = "Stage: " + str(Data.stage.get_current_stage())
