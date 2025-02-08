extends Node

# Registry of stores (StringName -> ReactiveStore)
var _stores: Dictionary = {}


# ------------------------------------------------------------------------------#
# Public API
# ------------------------------------------------------------------------------#
func register(name: StringName, store: ReactiveStore) -> void:
	_stores[name] = store


func get_store(name: StringName) -> ReactiveStore:
	assert(_stores.has(name), "Store %s not registered" % name)
	return _stores[name]


func override(name: StringName, store: ReactiveStore) -> void:
	_stores[name] = store


func reset() -> void:
	_stores.clear()
	_initialize_default_stores()


# ------------------------------------------------------------------------------#
# Initialization
# ------------------------------------------------------------------------------#
func _ready() -> void:
	_initialize_default_stores()


func _initialize_default_stores() -> void:
	# Register your default stores here
	register(&"Difficulty", DifficultyStore.new())
