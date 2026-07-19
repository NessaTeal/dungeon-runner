class_name ObjectSerializer

static func serialize(object: Object) -> Dictionary:
	var result: Dictionary = {}
	result["__type"] = object.get_script().get_global_name()
	for prop: Dictionary[String, Variant] in get_serializable_properties(object):
		var name: String = prop.name
		var value: Variant = object.get(name)
		result[name] = _encode_value(value)
	return result

static func deserialize(dict: Dictionary) -> Object:
	var typeName: String = dict.get("__type")
	var object: Object = _script_for_type(typeName).new()

	for prop: Dictionary[String, Variant] in get_serializable_properties(object):
		var name: String = prop.name
		if not dict.has(name):
			continue
		var decoded_value: Variant = _decode_value(dict[name])
		if decoded_value is Array array:
			var target_array = object[name] as Array
			for value in array:
				target_array.push_back(value)
		elif decoded_value is Dictionary dictionary:
			var target_dictionary = object[name] as Dictionary
			for key in dictionary.keys():
				target_dictionary[key] = dictionary[key]
		else:
			object.set(name, decoded_value)
	return object

static func get_serializable_properties(object: Object) -> Array[Dictionary[String, Variant]]:
	return object.get_property_list().filter(func(property): return _is_serializable(property))

static func _encode_value(value: Variant) -> Variant:
	if value is Resource resource:
		return serialize(resource)
	if value is Array:
		var arr: Array = []
		for item: Variant in value:
			arr.append(_encode_value(item))
		return arr
	return value

static func _decode_value(value: Variant) -> Variant:
	# Nested Object encoded as a dict with a __type tag
	if value is Dictionary dictionary:
		if dictionary.has("__type"):
			return deserialize(dictionary)
	# Typed array — decode each element
	if value is Array array:
		var result: Array = []
		for item: Variant in array:
			if item is Dictionary dictionary:
				if dictionary.has("__type"):
					result.append(deserialize(dictionary))
			else:
				result.append(item)
		return result
	return value

static func _is_serializable(prop: Dictionary) -> bool:
	var usage: int = prop.usage
	return usage & PROPERTY_USAGE_STORAGE and not usage & PROPERTY_USAGE_INTERNAL

static func _script_for_type(typeName: String) -> GDScript:
	# Global class names are registered — resolve via the class list
	for entry: Dictionary[String, Variant] in ProjectSettings.get_global_class_list():
		if entry["class"] == typeName:
			return load(entry["path"])
	push_error("Unknown type: %s" % typeName)
	return null
