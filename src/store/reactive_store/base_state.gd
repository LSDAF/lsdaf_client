class_name BaseState extends Node


static func get_property_types() -> Dictionary:
	push_error("BaseState.get_property_types() must be overridden")
	return {}


static func get_initial_state() -> Dictionary:
	push_error("BaseState.get_initial_state() must be overridden")
	return {}
