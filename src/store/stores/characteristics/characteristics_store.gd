class_name CharacteristicsStore extends ReactiveStore

# Type definitions
var attack: int:
	get:
		return _get_property(&"attack")
	set(v):
		set_property(&"attack", v)

var crit_chance: int:
	get:
		return _get_property(&"crit_chance")
	set(v):
		set_property(&"crit_chance", v)

var crit_damage: int:
	get:
		return _get_property(&"crit_damage")
	set(v):
		set_property(&"crit_damage", v)

var health: int:
	get:
		return _get_property(&"health")
	set(v):
		set_property(&"health", v)

var resistance: int:
	get:
		return _get_property(&"resistance")
	set(v):
		set_property(&"resistance", v)


func _init() -> void:
	_allowed_types = {
		&"attack": TYPE_INT,
		&"crit_chance": TYPE_INT,
		&"crit_damage": TYPE_INT,
		&"health": TYPE_INT,
		&"resistance": TYPE_INT
	}
	_state = {"attack": 0, "crit_chance": 0, "crit_damage": 0, "health": 0, "resistance": 0}


# Actions
func set_characteristics(
	attack_level: int,
	crit_chance_level: int,
	crit_damage_level: int,
	health_level: int,
	resistance_level: int
) -> void:
	attack = attack_level
	crit_chance = crit_chance_level
	crit_damage = crit_damage_level
	health = health_level
	resistance = resistance_level
