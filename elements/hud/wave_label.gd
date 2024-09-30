extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Data.stage.current_wave_updated.connect(update_current_wave_updated)
	text = "Wave: " + str(Data.stage.get_current_wave()) + "/" + str(Data.stage.get_max_wave())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func update_current_wave_updated(new_stage: int) -> void:
	text = "Wave: " + str(Data.stage.get_current_wave()) + "/" + str(Data.stage.get_max_wave())
