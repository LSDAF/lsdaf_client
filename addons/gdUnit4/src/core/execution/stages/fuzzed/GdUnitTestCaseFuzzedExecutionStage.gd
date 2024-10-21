## The test case execution stage.[br]
class_name GdUnitTestCaseFuzzedExecutionStage
extends IGdUnitExecutionStage

var _stage_before: IGdUnitExecutionStage = GdUnitTestCaseBeforeStage.new(false)
var _stage_after: IGdUnitExecutionStage = GdUnitTestCaseAfterStage.new(false)
var _stage_test: IGdUnitExecutionStage = GdUnitTestCaseFuzzedTestStage.new()


func _execute(context: GdUnitExecutionContext) -> void:
	while context.retry_execution():
		var test_context := GdUnitExecutionContext.of(context)
		await _stage_before.execute(test_context)
		if not context.test_case.is_skipped():
			await _stage_test.execute(GdUnitExecutionContext.of(test_context))
		await _stage_after.execute(test_context)
		if test_context.is_success() or test_context.is_skipped() or test_context.is_interupted():
			break
	context.evaluate_test_retry_status()


func set_debug_mode(debug_mode: bool = false) -> void:
	super.set_debug_mode(debug_mode)
	_stage_before.set_debug_mode(debug_mode)
	_stage_after.set_debug_mode(debug_mode)
	_stage_test.set_debug_mode(debug_mode)
