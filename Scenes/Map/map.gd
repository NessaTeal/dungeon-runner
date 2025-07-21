@tool

extends Node2D

@export var chunk_scene: PackedScene

var chunk_map = {}

var thread: Thread
var stop_the_thread = false
var semaphore: Semaphore
var requests: Array[Vector2i] = []

func _ready() -> void:
	#if Engine.is_editor_hint():
		#var chunk = chunk_scene.instantiate();
		#chunk.generate_chunk()
		#chunk.set_position(Vector2(0, 0))
		#add_child.call_deferred(chunk)
		#chunk_map[[0, 0]] = chunk
	#else:
		#semaphore = Semaphore.new()
		#thread = Thread.new()
		#thread.start(_thread_function)
		#update_map(Vector2(0, 0))
	semaphore = Semaphore.new()
		
	if !Engine.is_editor_hint():
		thread = Thread.new()
		thread.start(_thread_function)
	
	update_map(Vector2(0, 0))

func get_chunk(x, y):
	var chunk = chunk_map.get("%d,%d" % [x, y])
	if !chunk:
		var left = chunk_map.get("%d,%d" % [x - 1, y])
		var right = chunk_map.get("%d,%d" % [x + 1, y])
		var top = chunk_map.get("%d,%d" % [x, y - 1])
		var bottom = chunk_map.get("%d,%d" % [x, y + 1])
		
		chunk = chunk_scene.instantiate();
		
		chunk.left = null if !left else left.nodes[-1]
		chunk.right = null if !right else right.nodes[0]
		chunk.top = null if !top else top.nodes.map(func(x_vector): return x_vector[-1])
		chunk.bottom = null if !bottom else bottom.nodes.map(func(x_vector): return x_vector[0])
		
		chunk.generate_chunk()
		
		chunk.set_position(Vector2(x * Chunk.CHUNK_SIZE, y * Chunk.CHUNK_SIZE))
		add_child.call_deferred(chunk)
		
		chunk_map["%d,%d" % [x, y]] = chunk
		
func _thread_function():
	while true:
		semaphore.wait()
		
		if stop_the_thread:
			return
		
		for request in requests:
			get_chunk(request.x, request.y)
			
		requests = []
		
		if Engine.is_editor_hint():
			return

func update_map(player_position: Vector2):
	var x = round(player_position.x / Chunk.CHUNK_SIZE)
	var y = round(player_position.y / Chunk.CHUNK_SIZE)
	var map_size = 2
	
	for dx in range(-map_size, map_size + 1):
		for dy in range(-map_size, map_size + 1):
			if Engine.is_editor_hint():
				get_chunk(x + dx, y + dy)
			else:
				requests.push_back(Vector2i(x + dx, y + dy))
	
	semaphore.post()

func _exit_tree() -> void:
	if !Engine.is_editor_hint():
		stop_the_thread = true
		semaphore.post()
		await thread.wait_to_finish()
