class_name ArrayUtils


static func find_index_predicate(array: Array, predicate: Callable) -> int:
	for i in range(array.size()):
		var predicate_result: Variant = predicate.call(array[i])
		if predicate_result is bool and predicate_result == true:
			return i
	return -1
