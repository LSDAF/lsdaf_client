class_name FetchStageDto

var current_stage: int
var max_stage: int


func _init(dictionary: Dictionary) -> void:
	current_stage = dictionary["current_stage"]
	max_stage = dictionary["max_stage"]


func to_dictionary() -> Dictionary:
	return {
		"current_stage": current_stage,
		"max_stage": max_stage,
	}
