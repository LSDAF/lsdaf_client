class_name DifficultyStore extends ReactiveStore

var current_difficulty_property := ReactiveStoreProperty.new(self, &"current_difficulty")

# Type definitions
var current_difficulty: float:
	get:
		return await current_difficulty_property.get_value()
	set(v):
		current_difficulty_property.set_value(v)


func _init() -> void:
	_define_properties(DifficultyState.get_property_types(), DifficultyState.get_initial_state())


func _inject_dependencies(stores: StoreContainer) -> void:
	super._inject_dependencies(stores)


# Actions
func set_current_difficulty(new_difficulty: float) -> void:
	set_properties({&"current_difficulty": new_difficulty})
