class_name ReactiveStore extends Node

signal property_changed(property: StringName)
signal initialized

var _allowed_types := {}
var _state := {}
var _computeds := {}
var _current_computed := &""
var _dependencies_injected := false
var _store_initialized := false
var _initialization_in_progress := false


# Called by subclasses to set up properties
func _define_properties(allowed_types: Dictionary, initial_state: Dictionary) -> void:
	_initialization_in_progress = true
	_allowed_types = allowed_types
	_state = initial_state
	_store_initialized = true
	initialized.emit()


func set_properties(properties: Dictionary) -> void:
	var changed_properties: Array[StringName] = []

	for name: StringName in properties.keys():
		var value: Variant = properties[name]
		assert(_allowed_types.has(name), "Undefined property: %s" % name)
		assert(
			typeof(value) == _allowed_types[name],
			"Type mismatch for %s (Expected %s)" % [name, _allowed_types[name]]
		)

		if _state.get(name) != value:
			_state[name] = value
			_invalidate_dependents(name)
			changed_properties.append(name)

	for name: StringName in changed_properties:
		property_changed.emit(name)


# Optional method for initialization
func _initialize() -> void:
	pass


# Optional method for stores that need dependencies
func _inject_dependencies(_stores: StoreManager) -> void:
	# Stores can override this to get typed references to other stores
	_dependencies_injected = true


# Optional method for post-initialization
func _on_all_stores_initialized() -> void:
	# Stores can override this for post-initialization logic
	pass


# Public API
func set_property(name: StringName, value: Variant) -> void:
	assert(_allowed_types.has(name), "Undefined property: %s" % name)
	assert(
		typeof(value) == _allowed_types[name],
		"Type mismatch for %s (Expected %s)" % [name, _allowed_types[name]]
	)

	if _state.get(name) != value:
		_state[name] = value
		_invalidate_dependents(name)
		property_changed.emit(name)


func define_computed(name: StringName, getter: Callable) -> void:
	_computeds[name] = {"getter": getter, "deps": {}, "value": null, "stale": true}


# Internal logic
func _get_property(name: StringName) -> Variant:
	# Handle initialization
	if not _store_initialized:
		if not _initialization_in_progress:
			push_error("Store accessed before initialization started")
			return null
		await initialized

	# Validate property exists
	if not _allowed_types.has(name):
		push_error("Attempting to access undefined property '%s'" % name)
		return null

	# Track dependency
	if _current_computed != &"":
		_computeds[_current_computed].deps[name] = true

	# Return property value
	if name in _computeds:
		return await _get_computed_value(name)
	return _state.get(name)


func _get_computed_value(name: StringName) -> Variant:
	var comp: Variant = _computeds[name]

	if comp.stale:
		var prev: StringName = _current_computed
		_current_computed = name
		comp.deps.clear()
		var new_value: Variant = await comp.getter.call()

		# Only emit property_changed if the value actually changed
		if new_value != comp.value:
			comp.value = new_value
			property_changed.emit(name)
		else:
			comp.value = new_value  # Still update to maintain consistency

		comp.stale = false
		_current_computed = prev

	return comp.value


func _invalidate_dependents(changed: StringName) -> void:
	for computed: Variant in _computeds:
		if changed in _computeds[computed].deps:
			_computeds[computed].stale = true
