class_name StageService

var _stage_store: StageStore
var _current_quest_service: CurrentQuestService
var _difficulty_store: DifficultyStore


func _init(
	stage_store: StageStore,
	current_quest_service: CurrentQuestService,
	difficulty_store: DifficultyStore
) -> void:
	_stage_store = stage_store
	_current_quest_service = current_quest_service
	_difficulty_store = difficulty_store

	# Connect to store changes
	_stage_store.current_stage_property.changed.connect(_on_stage_changed)


func _on_stage_changed(_old_value: int, new_value: int) -> void:
	_difficulty_store.set_current_difficulty(float(new_value))


func get_current_stage() -> int:
	return await _stage_store.current_stage_property.get_value()


func get_current_wave() -> int:
	return await _stage_store.current_wave_property.get_value()


func get_max_stage() -> int:
	return await _stage_store.max_stage_property.get_value()


func get_max_wave() -> int:
	return await _stage_store.max_wave_property.get_value()


func is_boss_wave() -> bool:
	return await _stage_store.is_boss_wave_computed.get_value()


func set_current_stage(new_current_stage: int) -> void:
	_stage_store.set_current_stage(new_current_stage)


func set_current_wave(new_current_wave: int) -> void:
	_stage_store.set_current_wave(new_current_wave)


func set_max_stage(new_max_stage: int) -> void:
	_stage_store.set_max_stage(new_max_stage)


func beat_current_wave() -> void:
	# Check if this wave completion will result in a stage completion
	var will_complete_stage: bool = (
		(await _stage_store.current_wave_property.get_value() + 1)
		> await _stage_store.max_wave_property.get_value()
	)

	if (
		will_complete_stage
		and (
			await _stage_store.current_stage_property.get_value()
			== await _stage_store.max_stage_property.get_value()
		)
	):
		_current_quest_service.on_progress_stage()

	_stage_store.beat_current_wave()


func beat_current_stage() -> void:
	_stage_store.beat_current_stage()
