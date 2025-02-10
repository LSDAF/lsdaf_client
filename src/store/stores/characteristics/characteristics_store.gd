class_name CharacteristicsStore extends ReactiveStore

var attack_property := ReactiveStoreProperty.new(self, &"attack"):
	set(_value):
		push_error("attack_property cannot be reassigned. Use actions to modify the value.")

var crit_chance_property := ReactiveStoreProperty.new(self, &"crit_chance"):
	set(_value):
		push_error("crit_chance_property cannot be reassigned. Use actions to modify the value.")

var crit_damage_property := ReactiveStoreProperty.new(self, &"crit_damage"):
	set(_value):
		push_error("crit_damage_property cannot be reassigned. Use actions to modify the value.")

var health_property := ReactiveStoreProperty.new(self, &"health"):
	set(_value):
		push_error("health_property cannot be reassigned. Use actions to modify the value.")

var resistance_property := ReactiveStoreProperty.new(self, &"resistance"):
	set(_value):
		push_error("resistance_property cannot be reassigned. Use actions to modify the value.")


func _init() -> void:
	_initialize_reactive_store(
		CharacteristicsState.get_property_types(), CharacteristicsState.get_initial_state()
	)


# Actions
func set_characteristics(
	_attack: int, _crit_chance: int, _crit_damage: int, _health: int, _resistance: int
) -> void:
	set_properties(
		{
			&"attack": Characteristic.new(_attack),
			&"crit_chance": Characteristic.new(_crit_chance),
			&"crit_damage": Characteristic.new(_crit_damage),
			&"health": Characteristic.new(_health),
			&"resistance": Characteristic.new(_resistance)
		}
	)
