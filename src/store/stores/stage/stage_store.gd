class_name StageStore extends ReactiveStore

var current_stage_property := ReactiveStoreProperty.new(self, &"current_stage"):
	set(_value):
		push_error("current_stage_property cannot be reassigned. Use actions to modify the value.")

var current_wave_property := ReactiveStoreProperty.new(self, &"current_wave"):
	set(_value):
		push_error("current_wave_property cannot be reassigned. Use actions to modify the value.")

var max_stage_property := ReactiveStoreProperty.new(self, &"max_stage"):
	set(_value):
		push_error("max_stage_property cannot be reassigned. Use actions to modify the value.")

var max_wave_property := ReactiveStoreProperty.new(self, &"max_wave"):
	set(_value):
		push_error("max_wave_property cannot be reassigned. Use actions to modify the value.")

var is_boss_wave_computed := ReactiveStoreComputed.new(self, &"is_boss_wave"):
	set(_value):
		push_error("is_boss_wave_computed cannot be reassigned. Use actions to modify the value.")


func _init() -> void:
	_initialize_reactive_store(StageState.get_property_types(), StageState.get_initial_state())

	define_computed(
		&"is_boss_wave",
		func() -> bool:
			return await current_wave_property.get_value() == await max_wave_property.get_value()
	)


# Actions
func set_current_stage(new_stage: int) -> void:
	set_properties({&"current_stage": new_stage})


func set_current_wave(new_wave: int) -> void:
	set_properties({&"current_wave": new_wave})


func set_max_stage(new_max_stage: int) -> void:
	set_properties({&"max_stage": new_max_stage})


func set_max_wave(new_max_wave: int) -> void:
	set_properties({&"max_wave": new_max_wave})


func beat_current_stage() -> void:
	if await current_stage_property.get_value() == await max_stage_property.get_value():
		set_max_stage(await max_stage_property.get_value() + 1)

	set_current_stage(await current_stage_property.get_value() + 1)


func beat_current_wave() -> void:
	var new_wave: int = await current_wave_property.get_value() + 1

	if new_wave > await max_wave_property.get_value():
		await beat_current_stage()
		new_wave = 1

	set_current_wave(new_wave)
