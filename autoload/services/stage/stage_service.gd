class_name StageService

signal current_stage_updated(new_stage: int)
signal current_wave_updated(new_wave: int)


func get_current_stage() -> int:
	return Data.stage._current_stage


func get_current_wave() -> int:
	return Data.stage._current_wave


func get_max_stage() -> int:
	return Data.stage._max_stage


func get_max_wave() -> int:
	return Data.stage._max_wave


func is_boss_wave() -> bool:
	return Data.stage._current_wave == Data.stage._max_wave


func set_current_difficulty() -> void:
	Services.difficulty.set_current_difficulty(Data.stage._current_stage)


func set_current_stage(new_current_stage: int) -> void:
	Data.stage._current_stage = new_current_stage

	current_stage_updated.emit(new_current_stage)
	set_current_difficulty()


func set_current_wave(new_current_wave: int) -> void:
	Data.stage._current_wave = new_current_wave

	current_wave_updated.emit(new_current_wave)


func set_max_stage(new_max_stage: int) -> void:
	Data.stage._max_stage = new_max_stage


func beat_current_stage() -> void:
	if Data.stage._current_stage == Data.stage._max_stage:
		Data.stage._max_stage += 1
		Services.current_quest.on_progress_stage()

	set_current_stage(Data.stage._current_stage + 1)


func beat_current_wave() -> void:
	set_current_wave(Data.stage._current_wave + 1)

	if Data.stage._current_wave > Data.stage._max_wave:
		beat_current_stage()
		set_current_wave(1)
