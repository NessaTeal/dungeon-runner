class_name Utils

static func handled_connect(signall: Signal, callable: Callable, flags: int = 0) -> void:
	var err := signall.connect(callable, flags)
	if err:
		push_error("Error connecting signal %s" % error_string(err))

static func make_signal(p_obj: GDScript, p_signal_name: StringName, arguments: Array[Dictionary[String, Variant]] = []) -> Signal:
	p_obj.add_user_signal(p_signal_name, arguments)
	return Signal(p_obj, p_signal_name)

static func get_class_descendants(parent_class: GDScript):
	var classes_found = ProjectSettings.get_global_class_list().filter(func(clazz): return load(str(clazz.path)) == parent_class)
	var classes_remaining = ProjectSettings.get_global_class_list().filter(func(clazz): return load(str(clazz.path)) != parent_class)

	while true:
		var the_rest: Array[Dictionary]
		for clazz in classes_remaining:
			if classes_found.any(func(found: Dictionary): return found.class == clazz.base):
				classes_found.push_back(clazz)
			else:
				the_rest.push_back(clazz)
		
		if classes_remaining.size() == the_rest.size():
			break
		
		classes_remaining = the_rest
		
	return classes_found

const GRAVITY_VECTOR := Vector3(0, -9.8, 0)
#const GRAVITY_VECTOR := Vector3(0, 0, 0)
