class_name ReactiveStore extends RefCounted
signal property_changed(property: StringName)

var _allowed_types := {}
var _state := {}
var _computeds := {}
var _current_computed := &""


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
	if name in _computeds:
		return _get_computed_value(name)
	return _state.get(name)


func _get_computed_value(name: StringName) -> Variant:
	var comp: Variant = _computeds[name]

	if comp.stale:
		var prev := _current_computed
		_current_computed = name
		comp.deps.clear()
		comp.value = comp.getter.call()
		comp.stale = false
		_current_computed = prev

	if _current_computed != &"":
		comp.deps[_current_computed] = true

	return comp.value


func _invalidate_dependents(changed: StringName) -> void:
	for computed: Variant in _computeds:
		if changed in _computeds[computed].deps:
			_computeds[computed].stale = true
			property_changed.emit(computed)
