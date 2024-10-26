class_name StageService

var _stage_data: StageData

func _init(stage_data: StageData) -> void:
	_stage_data = stage_data

func get_current_stage() -> int:
	return _stage_data._current_stage


func get_current_wave() -> int:
	return _stage_data._current_wave


func get_max_stage() -> int:
	return _stage_data._max_stage


func get_max_wave() -> int:
	return _stage_data._max_wave


func is_boss_wave() -> bool:
	return _stage_data._current_wave == _stage_data._max_wave


func set_current_difficulty() -> void:
	Services.difficulty.set_current_difficulty(_stage_data._current_stage)


func set_current_stage(new_current_stage: int) -> void:
	_stage_data._current_stage = new_current_stage

	EventBus.current_stage_update.emit(new_current_stage)
	set_current_difficulty()


func set_current_wave(new_current_wave: int) -> void:
	_stage_data._current_wave = new_current_wave

	EventBus.current_wave_update.emit(new_current_wave)


func set_max_stage(new_max_stage: int) -> void:
	_stage_data._max_stage = new_max_stage


func beat_current_stage() -> void:
	if _stage_data._current_stage == _stage_data._max_stage:
		_stage_data._max_stage += 1
		Services.current_quest.on_progress_stage()

	set_current_stage(_stage_data._current_stage + 1)


func beat_current_wave() -> void:
	set_current_wave(_stage_data._current_wave + 1)

	if _stage_data._current_wave > _stage_data._max_wave:
		beat_current_stage()
		set_current_wave(1)
