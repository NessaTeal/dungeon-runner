extends Object
class_name Utils

static func handled_connect(signall: Signal, callable: Callable, flags: int = 0) -> void:
	var err := signall.connect(callable, flags)
	if err:
		push_error("Error connecting signal %s" % error_string(err))
