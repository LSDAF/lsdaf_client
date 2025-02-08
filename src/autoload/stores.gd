extends Node

signal initialized

var currencies := preload("res://src/store/stores/currencies/currencies_store.gd").new()
var characteristics := (
	preload("res://src/store/stores/characteristics/characteristics_store.gd").new()
)
var difficulty := preload("res://src/store/stores/difficulty/difficulty_store.gd").new()

# Registry of stores (StringName -> ReactiveStore)
var _stores: Dictionary = {}
var _initialized := false


func _init() -> void:
	print("init")

	await _initialize_default_stores()
	await _post_initialize_stores()


func register(name: StringName, store: ReactiveStore) -> void:
	_stores[name] = store
	if store != null and _initialized and store.has_method("_inject_dependencies"):
		store._inject_dependencies(_stores)


func override(name: StringName, store: ReactiveStore) -> void:
	_stores[name] = store
	if store != null and _initialized and store.has_method("_inject_dependencies"):
		store._inject_dependencies(_stores)


func _initialize_default_stores() -> Signal:
	register(&"Difficulty", difficulty)
	register(&"Currencies", currencies)
	register(&"Characteristics", characteristics)
	return initialized


func _post_initialize_stores() -> Signal:
	for store: ReactiveStore in _stores.values():
		if store != null:
			if not store._store_initialized:
				await store.initialized
			if store.has_method("_on_all_stores_initialized"):
				store._on_all_stores_initialized()

	_initialized = true
	initialized.emit()
	return initialized


func reset() -> void:
	await _initialize_default_stores()
	await _post_initialize_stores()
