extends GutTest

var sut: ItemPools


func before_each() -> void:
	sut = preload("res://src/models/items/item_blueprint/pools/item_pools.gd").new()


func test_get_blueprint_from_id_normal() -> void:
	# Arrange
	var test_blueprint := ItemBlueprint.new()
	test_blueprint.id = "sword_normal_1"
	test_blueprint.name = "Test Normal Sword"
	test_blueprint.texture = PlaceholderTexture2D.new()

	var test_pool := ItemPool.new()
	test_pool.normal = [test_blueprint]

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
	assert_eq(result.name, "Test Normal Sword")
	assert_eq(result.texture.get_class(), "PlaceholderTexture2D")


func test_get_blueprint_from_id_rare() -> void:
	# Arrange
	var test_blueprint := ItemBlueprint.new()
	test_blueprint.id = "sword_rare_1"
	test_blueprint.name = "Test Rare Sword"
	test_blueprint.texture = PlaceholderTexture2D.new()

	var test_pool := ItemPool.new()
	test_pool.rare = [test_blueprint]

	sut.boots = ItemPool.new()
	sut.chestplates = ItemPool.new()
	sut.gloves = ItemPool.new()
	sut.helmets = ItemPool.new()
	sut.shields = ItemPool.new()
	sut.swords = test_pool

	# Act
	var result: ItemBlueprint = sut.get_blueprint_from_id("sword_rare_1")

	# Assert
	assert_not_null(result)
	assert_eq(result.id, "sword_rare_1")
	assert_eq(result.name, "Test Rare Sword")
	assert_eq(result.texture.get_class(), "PlaceholderTexture2D")


func test_get_blueprint_from_id_magic() -> void:
	# Arrange
	var test_blueprint := ItemBlueprint.new()
	test_blueprint.id = "sword_magic_1"
	test_blueprint.name = "Test Magic Sword"
	test_blueprint.texture = PlaceholderTexture2D.new()

	var test_pool := ItemPool.new()
	test_pool.magic = [test_blueprint]

	sut.boots = ItemPool.new()
	sut.chestplates = ItemPool.new()
	sut.gloves = ItemPool.new()
	sut.helmets = ItemPool.new()
	sut.shields = ItemPool.new()
	sut.swords = test_pool

	# Act
	var result: ItemBlueprint = sut.get_blueprint_from_id("sword_magic_1")

	# Assert
	assert_not_null(result)
	assert_eq(result.id, "sword_magic_1")
	assert_eq(result.name, "Test Magic Sword")
	assert_eq(result.texture.get_class(), "PlaceholderTexture2D")


func test_get_blueprint_from_id_epic() -> void:
	# Arrange
	var test_blueprint := ItemBlueprint.new()
	test_blueprint.id = "sword_epic_1"
	test_blueprint.name = "Test Epic Sword"
	test_blueprint.texture = PlaceholderTexture2D.new()

	var test_pool := ItemPool.new()
	test_pool.epic = [test_blueprint]

	sut.boots = ItemPool.new()
	sut.chestplates = ItemPool.new()
	sut.gloves = ItemPool.new()
	sut.helmets = ItemPool.new()
	sut.shields = ItemPool.new()
	sut.swords = test_pool

	# Act
	var result: ItemBlueprint = sut.get_blueprint_from_id("sword_epic_1")

	# Assert
	assert_not_null(result)
	assert_eq(result.id, "sword_epic_1")
	assert_eq(result.name, "Test Epic Sword")
	assert_eq(result.texture.get_class(), "PlaceholderTexture2D")


func test_get_blueprint_from_id_legendary() -> void:
	# Arrange
	var test_blueprint := ItemBlueprint.new()
	test_blueprint.id = "sword_legendary_1"
	test_blueprint.name = "Test Legendary Sword"
	test_blueprint.texture = PlaceholderTexture2D.new()

	var test_pool := ItemPool.new()
	test_pool.legendary = [test_blueprint]

	sut.boots = ItemPool.new()
	sut.chestplates = ItemPool.new()
	sut.gloves = ItemPool.new()
	sut.helmets = ItemPool.new()
	sut.shields = ItemPool.new()
	sut.swords = test_pool

	# Act
	var result: ItemBlueprint = sut.get_blueprint_from_id("sword_legendary_1")

	# Assert
	assert_not_null(result)
	assert_eq(result.id, "sword_legendary_1")
	assert_eq(result.name, "Test Legendary Sword")
	assert_eq(result.texture.get_class(), "PlaceholderTexture2D")


func test_get_blueprint_from_id_mythic() -> void:
	# Arrange
	var test_blueprint := ItemBlueprint.new()
	test_blueprint.id = "sword_mythic_1"
	test_blueprint.name = "Test Mythic Sword"
	test_blueprint.texture = PlaceholderTexture2D.new()

	var test_pool := ItemPool.new()
	test_pool.mythic = [test_blueprint]

	sut.boots = ItemPool.new()
	sut.chestplates = ItemPool.new()
	sut.gloves = ItemPool.new()
	sut.helmets = ItemPool.new()
	sut.shields = ItemPool.new()
	sut.swords = test_pool

	# Act
	var result: ItemBlueprint = sut.get_blueprint_from_id("sword_mythic_1")

	# Assert
	assert_not_null(result)
	assert_eq(result.id, "sword_mythic_1")
	assert_eq(result.name, "Test Mythic Sword")
	assert_eq(result.texture.get_class(), "PlaceholderTexture2D")


func test_get_blueprint_from_id_not_found() -> void:
	# Arrange
	var test_pool := ItemPool.new()
	test_pool.normal = []
	test_pool.rare = []
	test_pool.magic = []
	test_pool.epic = []
	test_pool.legendary = []
	test_pool.mythic = []

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
