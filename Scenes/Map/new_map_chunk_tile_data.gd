extends Resource
class_name NewMapChunkTileData

@export var position: Vector2i
@export var tile_data: Color

func _init(p_position: Vector2i = Vector2i(0, 0), p_tile_data: Color = Color()) -> void:
	self.position = p_position
	self.tile_data = p_tile_data
