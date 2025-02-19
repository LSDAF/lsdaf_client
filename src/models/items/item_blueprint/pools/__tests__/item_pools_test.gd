extends GutTest

var sut: ItemPools


func before_each() -> void:
	sut = preload("res://src/models/items/item_blueprint/pools/item_pools.gd").new()


func test_get_blueprint_from_id() -> void:
	# Arrange
	var test_blueprint := ItemBlueprint.new()
	test_blueprint.id = "sword_normal_1"
	test_blueprint.name = "Test Sword"
	test_blueprint.texture = PlaceholderTexture2D.new()

	var test_pool := ItemPool.new()
	test_pool.normal = [test_blueprint]
	test_pool.rare = []

	sut.boots = ItemPool.new()
	sut.chestplates = ItemPool.new()
	sut.gloves = ItemPool.new()
	sut.helmets = ItemPool.new()
	sut.shields = ItemPool.new()
	sut.swords = test_pool

	# Act
	var result: ItemBlueprint = sut.get_blueprint_from_id("sword_normal_1")

	# Assert
	assert_not_null(result)
	assert_eq(result.id, "sword_normal_1")
	assert_eq(result.name, "Test Sword")
	assert_eq(result.texture.get_class(), "PlaceholderTexture2D")


func test_get_blueprint_from_id_not_found() -> void:
	# Arrange
	var test_pool := ItemPool.new()
	test_pool.normal = []
	test_pool.rare = []

	sut.boots = ItemPool.new()
	sut.chestplates = ItemPool.new()
	sut.gloves = ItemPool.new()
	sut.helmets = ItemPool.new()
	sut.shields = ItemPool.new()
	sut.swords = test_pool

	# Act
	var result: ItemBlueprint = sut.get_blueprint_from_id("nonexistent_id")

	# Assert
	assert_null(result)
