extends Node

const CurrenciesStore := preload("res://src/store/stores/currencies/currencies_store.gd")
const CharacteristicsStore := preload(
	"res://src/store/stores/characteristics/characteristics_store.gd"
)

# Registry of stores (StringName -> ReactiveStore)
var _stores: Dictionary = {}
var _initialized := false


# ------------------------------------------------------------------------------#
# Public API
# ------------------------------------------------------------------------------#
func register(name: StringName, store: ReactiveStore) -> void:
	_stores[name] = store
	if _initialized and store.has_method("_inject_dependencies"):
		store._inject_dependencies(_stores)


func get_store(name: StringName) -> ReactiveStore:
	assert(_stores.has(name), "Store %s not registered" % name)
	var store: ReactiveStore = _stores[name]

	# If store supports dependency injection and hasn't been initialized
	if not _initialized and store.has_method("_inject_dependencies"):
		store._inject_dependencies(_stores)

	return store


func override(name: StringName, store: ReactiveStore) -> void:
	_stores[name] = store
	if _initialized and store.has_method("_inject_dependencies"):
		store._inject_dependencies(_stores)


func reset() -> void:
	_stores.clear()
	_initialized = false
	_initialize_default_stores()


# ------------------------------------------------------------------------------#
# Initialization
# ------------------------------------------------------------------------------#
func _ready() -> void:
	_initialize_default_stores()
	_post_initialize_stores()


func _initialize_default_stores() -> void:
	# Register your default stores here
	register(&"Difficulty", DifficultyStore.new())
	register(&"Currencies", CurrenciesStore.new())
	register(&"Characteristics", CharacteristicsStore.new())


func _post_initialize_stores() -> void:
	# Call post-initialization on all stores
	for store: ReactiveStore in _stores.values():
		if store.has_method("_on_all_stores_initialized"):
			store._on_all_stores_initialized()
	_initialized = true
