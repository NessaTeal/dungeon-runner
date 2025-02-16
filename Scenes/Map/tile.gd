extends RefCounted

class_name Tile

var weights = {"r": 1, "d": 1, "s": 1, "g": 1}
var selected_option: String
var x: int
var y: int

var confidence = -1

func add_half_of_weights(terrain):
	weights[terrain] += 5.0 / weights[terrain] + Utils.reduce(weights.values(), func(acc, cur): return acc + cur, 0) / 2

func _init(x, y) -> void:
	self.x = x
	self.y = y
