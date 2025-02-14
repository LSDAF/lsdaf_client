class_name ReactiveStoreComputed extends Node

var _store: ReactiveStore
var _property_name: StringName


func _init(store: ReactiveStore, property_name: StringName) -> void:
	_store = store
	_property_name = property_name


func get_value() -> Variant:
	return await _store._get_property(_property_name)
