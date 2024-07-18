extends Node

signal current_stage_updated(new_stage: int)

var _current_stage := 1
var _max_stage := 1

func get_current_stage() -> int:
	return _current_stage
	
func set_current_stage(new_current_stage: int) -> void:
	_current_stage = new_current_stage
	current_stage_updated.emit(new_current_stage)

func beat_current_stage():
	if (_current_stage == _max_stage):
		_max_stage += 1
	set_current_stage(_current_stage + 1)
