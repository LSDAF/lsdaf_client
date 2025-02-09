class_name StoreManager extends Node

signal initialized

var _initialized := false
var _stores: Array[Node] = []
var _store_dict: Dictionary = {}


func register_store(store: Node) -> void:
	_stores.append(store)
	_store_dict[store.name] = store
	add_child(store)


func get_store(store_name: String) -> Node:
	return _store_dict.get(store_name)


func _validate_stores() -> void:
	for store in _stores:
		assert(store != null, "Store cannot be null: %s" % store.name)


func _wait_for_store_initialization() -> void:
	for store in _stores:
		if store.has_method("_store_initialized") and not store._store_initialized:
			await store.initialized


func _inject_store_dependencies() -> void:
	for store in _stores:
		if store.has_method("_inject_dependencies"):
			store._inject_dependencies(self)


func _call_post_initialization() -> void:
	for store in _stores:
		if store.has_method("_on_all_stores_initialized"):
			store._on_all_stores_initialized()


func initialize() -> void:
	_validate_stores()
	await _wait_for_store_initialization()
	_inject_store_dependencies()
	_call_post_initialization()

	_initialized = true
	initialized.emit()


func _cleanup_stores() -> void:
	_store_dict.clear()
	_stores.clear()

	for child in get_children():
		remove_child(child)
		child.queue_free()


func replace_store(store_name: StringName, store: Node) -> void:
	set(store_name, store)
	_store_dict.clear()
	await initialize()


func replace_stores_with_doubles(doubles: Dictionary) -> void:
	_cleanup_stores()

	# Set new doubles and add as children
	for store_name: StringName in doubles:
		var double: Node = doubles[store_name]
		set(store_name, double)
		add_child(double)

	await initialize()
