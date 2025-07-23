extends Resource
class_name Chunk

@export var nodes: Variant
@export var texture: ImageTexture

func _init(_nodes, _texture: ImageTexture) -> void:
	nodes = _nodes
	texture = _texture
