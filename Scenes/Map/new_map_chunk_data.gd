extends Resource
class_name NewMapChunkData

@export var tiles: Array[NewMapChunkTileData]

func _init(p_tiles: Array[NewMapChunkTileData] = []) -> void:
	self.tiles = p_tiles
