extends MultiMeshInstance3D
class_name NewMapChunk

static var GENERATION_POINTS := 17
static var TILE_COUNT := (GENERATION_POINTS - 1) * 2
static var MULTIMESH_INSTANCE_COUNT := TILE_COUNT * TILE_COUNT
static var TILE_SIZE := 1
static var CHUNK_SIZE := TILE_COUNT * TILE_SIZE

static var TERRAIN_OPTIONS: Array[String] = ["g", "s", "r", "d"]
static var PRIO: Dictionary[String, int] = {"r": 0, "d": 1, "s": 2, "g": 3}

var chunk_data: NewMapChunkData

func _ready() -> void:
	assert(chunk_data, "Chunk data was not passed to chunk")
	multimesh.instance_count = len(chunk_data.tiles)
	
	for tile_index in len(chunk_data.tiles):
		var tile_data := chunk_data.tiles[tile_index]
		
		multimesh.set_instance_transform(tile_index, Transform3D(Basis(), Vector3(tile_data.position.x * TILE_SIZE, 0, tile_data.position.y * TILE_SIZE)))
		multimesh.set_instance_custom_data(tile_index, tile_data.tile_data)
	
	for collectible_key: Vector2i in chunk_data.collectibles.keys():
		var collectible_scene = chunk_data.collectibles[collectible_key].instantiate() as Node3D
		
		collectible_scene.set_transform(Transform3D(Basis(), Vector3(collectible_key.x * TILE_SIZE, 0, collectible_key.y * TILE_SIZE)))
		
		add_child(collectible_scene)
	
	chunk_data = null
	
