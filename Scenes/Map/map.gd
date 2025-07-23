extends Node3D
class_name Map

@export var chunk_generator: ChunkGenerator
@export var map_tile_scene: PackedScene

var chunk_map: Dictionary[String, Chunk] = {}

#var thread: Thread
var stop_the_thread = false
var semaphore: Semaphore
var requests: Array[Vector2i] = []
var mutex: Mutex

func _ready() -> void:
	print("Started")
	semaphore = Semaphore.new()
	mutex = Mutex.new()
		
	var thread = Thread.new()
	thread.start(func():
		update_map(Vector2(0, 0)))
	

func get_chunk(x: int, y: int):
	var chunk_key = "%d,%d" % [x, y]
	print("chunk key", chunk_key)
	var chunk = chunk_map[chunk_key] if chunk_map.has(chunk_key) else null
	if !chunk:
		var left_key = "%d,%d" % [x - 1, y]
		var right_key = "%d,%d" % [x + 1, y]
		var top_key = "%d,%d" % [x, y - 1]
		var bottom_key = "%d,%d" % [x, y + 1]
		
		var maybe_left = chunk_map[left_key] if chunk_map.has(left_key) else null
		var maybe_right = chunk_map[right_key] if chunk_map.has(right_key) else null
		var maybe_top = chunk_map[top_key] if chunk_map.has(top_key) else null
		var maybe_bottom = chunk_map[bottom_key] if chunk_map.has(bottom_key) else null
		
		var left = null if !maybe_left else maybe_left.nodes[-1]
		var right = null if !maybe_right else maybe_right.nodes[0]
		var top = null if !maybe_top else maybe_top.nodes.map(func(x_vector): return x_vector[-1])
		var bottom = null if !maybe_bottom else maybe_bottom.nodes.map(func(x_vector): return x_vector[0])
		
		var new_chunk = await chunk_generator.generate_chunk(x, y, left, right, top, bottom)
		
		var map_tile = create_map_tile(new_chunk)
		map_tile.set_position(Vector3(x * ChunkGenerator.MAP_TILE_SIZE, 0, y * ChunkGenerator.MAP_TILE_SIZE))
		add_child(map_tile)
		

#func register_chunk(x: int, y: int, chunk: Chunk):
	#var chunk_key = "%d,%d" % [x, y]
	#var map_tile = create_map_tile(chunk)
	#map_tile.set_position(Vector3(x * ChunkGenerator.MAP_TILE_SIZE, 0, y * ChunkGenerator.MAP_TILE_SIZE))
	#add_child(map_tile)
	#
	#chunk_map[chunk_key] = chunk
	#
	#semaphore.post()

func _thread_function():
	while true:
		semaphore.wait()
		
		if stop_the_thread:
			return
			
		var request = requests.pop_back()
		get_chunk(request.x, request.y)
		

func create_map_tile(chunk: Chunk) -> MeshInstance3D:
	var new_mesh = MeshInstance3D.new()
	var plane_mesh = PlaneMesh.new()
	plane_mesh.size = Vector2(100.0, 100.0)
	new_mesh.mesh = plane_mesh
	var material = ORMMaterial3D.new()
	plane_mesh.surface_set_material(0, material)
	material.no_depth_test = true
	#var map_tile = map_tile_scene.instantiate() as MeshInstance3D
	#var material = (map_tile.mesh.surface_get_material(0) as ORMMaterial3D).duplicate()
	material.texture_filter = BaseMaterial3D.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS_ANISOTROPIC
	material.albedo_texture = chunk.texture
	#map_tile.mesh.surface_set_material(0, material)
	
	return new_mesh

func update_map(player_position: Vector2):
	#mutex.lock()
	#thread.start(_thread_function)
	var x = round(player_position.x / ChunkGenerator.MAP_TILE_SIZE)
	var y = round(player_position.y / ChunkGenerator.MAP_TILE_SIZE)
	var map_size = 2
	
	for dx in range(-map_size, map_size + 1):
		for dy in range(-map_size, map_size + 1):
			var thread = Thread.new()
			thread.start(func(): get_chunk(x + dx, y + dy))
			thread.wait_to_finish()
			
	#thread.start(callback)
	#thread.wait_to_finish()
	#mutex.unlock()
	#requests.push_back(Vector2i(0, 0))
	#requests.push_back(Vector2i(0, 1))
	
	#semaphore.post()

#func _exit_tree() -> void:
	#stop_the_thread = true
	#semaphore.post()
	#await thread.wait_to_finish()
