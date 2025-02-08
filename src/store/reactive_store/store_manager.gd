class_name StoreManager extends Node

signal initialized

var currencies: CurrenciesStore
var characteristics: CharacteristicsStore
var difficulty: DifficultyStore
var _initialized := false
var _store_container: StoreContainer


func _validate_stores() -> void:
	assert(currencies != null, "Currencies store cannot be null")
	assert(characteristics != null, "Characteristics store cannot be null")
	assert(difficulty != null, "Difficulty store cannot be null")


func _wait_for_store_initialization() -> void:
	if not currencies._store_initialized:
		await currencies.initialized
	if not characteristics._store_initialized:
		await characteristics.initialized
	if not difficulty._store_initialized:
		await difficulty.initialized


func _inject_store_dependencies() -> void:
	if not _store_container:
		_store_container = StoreContainer.new(currencies, characteristics, difficulty)
		add_child(_store_container)

	currencies._inject_dependencies(_store_container)
	characteristics._inject_dependencies(_store_container)
	difficulty._inject_dependencies(_store_container)


func _call_post_initialization() -> void:
	currencies._on_all_stores_initialized()
	characteristics._on_all_stores_initialized()
	difficulty._on_all_stores_initialized()


func initialize() -> void:
	_validate_stores()
	await _wait_for_store_initialization()
	_inject_store_dependencies()
	_call_post_initialization()

	_initialized = true
	initialized.emit()


func _cleanup_stores() -> void:
	if _store_container:
		_store_container.queue_free()
		_store_container = null

	for child in get_children():
		remove_child(child)
		child.queue_free()


func replace_store(store_name: StringName, store: Node) -> void:
	set(store_name, store)
	if _store_container:
		_store_container.queue_free()
		_store_container = null
	await initialize()


func replace_stores_with_doubles(doubles: Dictionary) -> void:
	_cleanup_stores()

	# Set new doubles and add as children
	for store_name: StringName in doubles:
		var double: Node = doubles[store_name]
		set(store_name, double)
		add_child(double)

	await initialize()
