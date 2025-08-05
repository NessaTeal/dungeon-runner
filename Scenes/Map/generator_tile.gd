extends RefCounted

class_name GeneratorTile

var weights: Dictionary[String, float] = {"r": 1, "d": 1, "s": 1, "g": 1}
var selected_option: String
var x: int
var y: int

var confidence := -1

func _init(_x: int, _y: int) -> void:
	x = _x
	y = _y
