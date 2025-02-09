extends RefCounted

class_name Tile

var options = TilesDefinitions.ALL_TILES.duplicate()
var selected_option: Dictionary
var x: int
var y: int

func _init(x, y) -> void:
	self.x = x
	self.y = y
