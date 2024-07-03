extends Object
class_name Utils

static func first_element_which(array, callback):
	for element in array:
		if callback.call(element):
			return element
			
	return null

static func flatmap(array, callback):
	var result = []
	array.map(callback)
	for item in array:
		for callback_item in callback.call(item):
			result.push_back(callback_item)
			
	return result

static func reduce(array, callback, accumulator):
	var result = accumulator
	for element in array:
		result = callback.call(result, element)
	return result
