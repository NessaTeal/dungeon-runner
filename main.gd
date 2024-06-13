extends Control

func _ready():
	(func(): get_parent().move_child(self, 0)).call_deferred()
