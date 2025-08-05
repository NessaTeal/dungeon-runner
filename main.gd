extends Node

func _ready() -> void:
	get_parent().move_child.call_deferred(self, 0)
