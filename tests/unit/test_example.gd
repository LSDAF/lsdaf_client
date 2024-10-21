extends GdUnitTestSuite


func test_string_to_lower() -> void:
	assert_str("AbcD".to_lower()).is_equal("abcd")
