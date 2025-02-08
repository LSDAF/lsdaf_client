class_name StageService

var _stage_data: StageData
var _current_quest_service: CurrentQuestService
var _difficulty_store: DifficultyStore


func _init(
	stage_data: StageData,
	current_quest_service: CurrentQuestService,
	difficulty_store: DifficultyStore
) -> void:
	_stage_data = stage_data
	_current_quest_service = current_quest_service
	_difficulty_store = difficulty_store


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


func set_current_stage(new_current_stage: int) -> void:
	_stage_data._current_stage = new_current_stage

	EventBus.current_stage_update.emit()
	_difficulty_store.set_current_difficulty(_stage_data._current_stage)


func set_current_wave(new_current_wave: int) -> void:
	_stage_data._current_wave = new_current_wave

	EventBus.current_wave_update.emit()


func set_max_stage(new_max_stage: int) -> void:
	_stage_data._max_stage = new_max_stage


func beat_current_stage() -> void:
	if _stage_data._current_stage == _stage_data._max_stage:
		_stage_data._max_stage += 1
		_current_quest_service.on_progress_stage()

	set_current_stage(_stage_data._current_stage + 1)


func beat_current_wave() -> void:
	set_current_wave(_stage_data._current_wave + 1)

	if _stage_data._current_wave > _stage_data._max_wave:
		beat_current_stage()
		set_current_wave(1)
