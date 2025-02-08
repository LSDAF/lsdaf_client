class_name CharacteristicsStore extends ReactiveStore

# Type definitions
var attack: int:
	get:
		return await _get_property(&"attack")
	set(v):
		set_property(&"attack", v)

var crit_chance: int:
	get:
		return await _get_property(&"crit_chance")
	set(v):
		set_property(&"crit_chance", v)

var crit_damage: int:
	get:
		return await _get_property(&"crit_damage")
	set(v):
		set_property(&"crit_damage", v)

var health: int:
	get:
		return await _get_property(&"health")
	set(v):
		set_property(&"health", v)

var resistance: int:
	get:
		return await _get_property(&"resistance")
	set(v):
		set_property(&"resistance", v)


func _init() -> void:
	_define_properties(
		{
			&"attack": TYPE_INT,
			&"crit_chance": TYPE_INT,
			&"crit_damage": TYPE_INT,
			&"health": TYPE_INT,
			&"resistance": TYPE_INT
		},
		{&"attack": 0, &"crit_chance": 0, &"crit_damage": 0, &"health": 0, &"resistance": 0}
	)


# Actions
func set_characteristics(
	_attack: int, _crit_chance: int, _crit_damage: int, _health: int, _resistance: int
) -> void:
	attack = _attack
	crit_chance = _crit_chance
	crit_damage = _crit_damage
	health = _health
	resistance = _resistance
