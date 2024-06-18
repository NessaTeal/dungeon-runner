extends Object

static func first_element_which(array, callback):
	for element in array:
		if callback.call(element):
			return element
			
	return null
