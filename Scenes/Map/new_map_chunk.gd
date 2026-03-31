extends MultiMeshInstance3D
class_name NewMapChunk

static var GENERATION_POINTS := 17
static var TILE_COUNT := (GENERATION_POINTS - 1) * 2
static var MULTIMESH_INSTANCE_COUNT := TILE_COUNT * TILE_COUNT
static var TILE_SIZE := 1
static var CHUNK_SIZE := TILE_COUNT * TILE_SIZE

static var TERRAIN_OPTIONS: Array[String] = ["g", "s", "r", "d"]
static var PRIO: Dictionary[String, int] = {"r": 0, "d": 1, "s": 2, "g": 3}

#@export var plane_mesh: PlaneMesh

#var multi_mesh = preload("res://Scenes/Map/new_map_chunk_multi_mesh.tres")

var chunk_data: NewMapChunkData

func _ready() -> void:
	#multimesh = MultiMesh.new()ad
	#multimesh.transform_format = MultiMesh.TRANSFORM_3Da
	#multimesh.use_custom_data = true;
	#multimesh.mesh = PlaneMesh.new()
	#multimesh.mesh.size = Vector2(1,1)
	#var shader_m = ShaderMaterial.new()
	#shader_m.shader = preload("res://Scenes/Map/new_map_chunk_shader.gdshader")
	#shader_m.set_shader_parameter("atlas", preload("res://Textures/Tiles/atlas.png"))
	#multimesh.mesh.surface_set_material(0, shader_m)
	#assert(plane_mesh, "Plane mesh of multimesh is not exported")
	assert(chunk_data, "Chunk data was not passed to chunk")
	multimesh.instance_count = len(chunk_data.tiles)
	#plane_mesh.size = Vector2(TILE_SIZE, TILE_SIZE)
	
	for tile_index in len(chunk_data.tiles):
		var tile_data := chunk_data.tiles[tile_index]
		
		multimesh.set_instance_transform(tile_index, Transform3D(Basis(), Vector3(tile_data.position.x * TILE_SIZE, 0, tile_data.position.y * TILE_SIZE)))
		multimesh.set_instance_custom_data(tile_index, tile_data.tile_data)
	
	for collectible_key: Vector2i in chunk_data.collectibles.keys():
		var collectible_scene := chunk_data.collectibles[collectible_key].instantiate() as Collectible
		
		collectible_scene.set_transform(Transform3D(Basis(), Vector3(collectible_key.x * TILE_SIZE, 0, collectible_key.y * TILE_SIZE)))
		
		add_child(collectible_scene)
	
	chunk_data = null
		
#func _process(delta: float) -> void:
	#var tile_data := chunk_data.tiles[index]
	#var red := tile_data.tile_data.r
	#var packed_byte = PackedByteArray([0, 0, 0, 0])
	#packed_byte.encode_float(0, red)
	##print(packed_byte)
	#multimesh.set_instance_transform(index, Transform3D(Basis(), Vector3(tile_data.position.x * TILE_SIZE, 0, tile_data.position.y * TILE_SIZE)))
	#multimesh.set_instance_custom_data(index, tile_data.tile_data)
	#index += 1;
 
