# gdlint: disable=class-definitions-order

class_name StageStoreTest extends GutTest

var sut: StageStore


func before_each() -> void:
	# Arrange
	sut = StageStore.new()
	add_child(sut)


func after_each() -> void:
	if is_instance_valid(sut):
		sut.queue_free()
	await get_tree().process_frame


func test_initial_state() -> void:
	# Arrange - done in before_each

	# Act & Assert
	assert_eq(await sut.current_stage_property.get_value(), 1)
	assert_eq(await sut.current_wave_property.get_value(), 1)
	assert_eq(await sut.max_stage_property.get_value(), 1)
	assert_eq(await sut.max_wave_property.get_value(), 3)


func test_set_current_stage() -> void:
	# Arrange - done in before_each

	# Act
	sut.set_current_stage(100)

	# Assert
	assert_eq(await sut.current_stage_property.get_value(), 100)


func test_set_current_wave() -> void:
	# Arrange - done in before_each

	# Act
	sut.set_current_wave(20)

	# Assert
	assert_eq(await sut.current_wave_property.get_value(), 20)


func test_set_max_stage() -> void:
	# Arrange - done in before_each

	# Act
	sut.set_max_stage(500)

	# Assert
	assert_eq(await sut.max_stage_property.get_value(), 500)


# Parameters
# [new_max_wave]
var test_set_max_wave_parameters := [
	[1],
	[3],
	[5],
	[10],
]


func test_set_max_wave(params: Array = use_parameters(test_set_max_wave_parameters)) -> void:
	# Arrange
	var new_max_wave: int = params[0]

	# Act
	sut.set_max_wave(new_max_wave)

	# Assert
	assert_eq(await sut.max_wave_property.get_value(), new_max_wave)


# Parameters
# [current_stage, max_stage]
var test_beat_current_stage_parameters := [
	[1, 10],  # Normal stage
	[9, 10],  # Near max stage
	[10, 10],  # At max stage
	[20, 20],  # At max stage (higher value)
]


func test_beat_current_stage(
	params: Array = use_parameters(test_beat_current_stage_parameters)
) -> void:
	# Arrange
	var current_stage: int = params[0]
	var max_stage: int = params[1]

	sut.set_current_stage(current_stage)
	sut.set_max_stage(max_stage)

	# Act
	await sut.beat_current_stage()

	# Assert
	assert_eq(await sut.current_stage_property.get_value(), current_stage + 1)
	if current_stage == max_stage:
		assert_eq(await sut.max_stage_property.get_value(), max_stage + 1)
	else:
		assert_eq(await sut.max_stage_property.get_value(), max_stage)


# Parameters
# [current_wave, max_wave, expected_result]
var test_is_boss_wave_parameters := [
	[1, 3, false],  # First wave
	[2, 3, false],  # Middle wave
	[3, 3, true],  # Boss wave
	[1, 5, false],  # First wave (different max)
	[4, 5, false],  # Pre-boss wave
	[5, 5, true],  # Boss wave (different max)
]


func test_is_boss_wave(params: Array = use_parameters(test_is_boss_wave_parameters)) -> void:
	# Arrange
	var current_wave: int = params[0]
	var max_wave: int = params[1]
	var expected_result: bool = params[2]

	sut.set_current_wave(current_wave)
	sut.set_max_wave(max_wave)

	# Act
	var is_boss_wave: bool = await sut._get_property(&"is_boss_wave")

	# Assert
	assert_eq(is_boss_wave, expected_result)


func test_property_change_signal_emitted() -> void:
	# Arrange
	watch_signals(sut)

	# Act
	sut.set_current_stage(100)
	assert_signal_emitted_with_parameters(sut, "property_changed", [&"current_stage"])

	sut.set_current_wave(20)
	assert_signal_emitted_with_parameters(sut, "property_changed", [&"current_wave"])

	sut.set_max_stage(500)
	assert_signal_emitted_with_parameters(sut, "property_changed", [&"max_stage"])

	sut.set_max_wave(10)
	assert_signal_emitted_with_parameters(sut, "property_changed", [&"max_wave"])


func test_computed_property_updates_when_dependencies_change() -> void:
	# Arrange
	sut.set_current_wave(2)
	sut.set_max_wave(3)
	assert_eq(await sut._get_property(&"is_boss_wave"), false)

	# Act
	sut.set_current_wave(3)

	# Assert
	assert_eq(await sut._get_property(&"is_boss_wave"), true)
