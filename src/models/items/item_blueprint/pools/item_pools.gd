class_name ItemPools
extends Resource

@export var boots: ItemPool
@export var chestplates: ItemPool
@export var gloves: ItemPool
@export var helmets: ItemPool
@export var shields: ItemPool
@export var swords: ItemPool


func get_blueprint_from_id(blueprint_id: String) -> ItemBlueprint:
	# Get all item pools
	var pools := [boots, chestplates, gloves, helmets, shields, swords]

	# Check both normal and rare blueprints
	for pool: ItemPool in pools:
		# Check normal rarity
		for blueprint: ItemBlueprint in pool.normal:
			if blueprint.id == blueprint_id:
				return blueprint

		# Check rare rarity
		for blueprint: ItemBlueprint in pool.rare:
			if blueprint.id == blueprint_id:
				return blueprint

	return null
