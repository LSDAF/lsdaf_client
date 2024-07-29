extends Node

signal current_stage_updated(new_stage: int)
signal current_wave_updated(new_wave: int)

var _current_stage := 1
var _current_wave := 1
var _max_stage := 1
var _max_wave := 3 # Boss is at _max_wave

func get_current_stage() -> int:
	return _current_stage
	
func get_current_wave() -> int:
	return _current_wave
	
func get_max_wave() -> int:
	return _max_wave
	
func is_boss_wave() -> bool:
	return _current_wave == _max_wave
	
func set_current_difficulty() -> void:
	Difficulty.set_current_difficulty(_current_stage)
	
func set_current_stage(new_current_stage: int) -> void:
	_current_stage = new_current_stage
	
	current_stage_updated.emit(new_current_stage)
	set_current_difficulty()
	
func set_current_wave(new_current_wave: int) -> void:
	_current_wave = new_current_wave
	
	current_wave_updated.emit(new_current_wave)

func beat_current_stage() -> void:
	set_current_stage(_current_stage + 1)
		
	if (_current_stage == _max_stage):
		_max_stage += 1

func beat_current_wave() -> void:
	set_current_wave(_current_wave + 1)

	if (_current_wave > _max_wave):
		beat_current_stage();
		set_current_wave(1)
