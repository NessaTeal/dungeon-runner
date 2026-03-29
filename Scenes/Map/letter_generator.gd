extends Node
class_name LetterGenerator

var letters: Dictionary[Vector2i, GeneratorTile] = {}

#static var SIZE: int = 9
#static var TILE_COUNT: int = (SIZE - 1) * 2
#static var TILE_SIZE: int = 128

static var ORIGINS: Dictionary[String, int] = {
	"r": 2,
	"d": 3,
	"s": 1,
	"g": 0
}
static var TERRAIN_OPTIONS: Array[String] = ["g", "s", "r", "d"]
static var PRIO: Dictionary[String, int] = {"r": 0, "d": 1, "s": 2, "g": 3}

signal publish_chunk(coords: Vector2i, chunk_data: NewMapChunkData)

var tasks: Array[Vector2i] = []
var all_tasks: Dictionary[Vector2i, bool] = {}
var thread: Thread
var thread_running := true
var mutex := Mutex.new()

func _ready() -> void:
	thread = Thread.new()
	thread.start(do_task)

func _exit_tree() -> void:
	thread_running = false
	thread.wait_to_finish()
	
var cur_tasaks: Array[Vector2i] = []

func worker_func(task_index: int) -> void:
	#print(task_index)
	var coords := cur_tasaks[task_index]
	
	var _x := coords.x * (NewMapChunk.GENERATION_POINTS - 1)
	var _y := coords.y * (NewMapChunk.GENERATION_POINTS - 1)
	
	#for xx in range(_x, _x + NewMapChunk.GENERATION_POINTS):
		#for yy in range(_y, _y + NewMapChunk.GENERATION_POINTS):
			#var letter_key := Vector2i(xx, yy)
			#if not letters.has(letter_key):
				#letters[letter_key] = GeneratorTile.new(xx, yy)
	# offset by 1 as edge letters can have all 4 neighbours already done if it's 4th tile in a corner
	update_neighbours(letters[Vector2i(_x + 1, _y + 1)])
	var tile_terrain_corners := calculate_tile_terrain_corners(Vector2i(_x, _y))
	#var patterns := calculate_layers(tile_terrain_corners)
	var chunk_data := calculate_chunk_data(tile_terrain_corners)
	#all_tasks[coords] = chunk_data

	publish_chunk.emit.call_deferred(coords, chunk_data)

func do_task() -> void:
	while thread_running:
		mutex.lock()
		cur_tasaks = tasks.duplicate()
		tasks.clear()
		mutex.unlock()
		for task in cur_tasaks:
			var _x := task.x * (NewMapChunk.GENERATION_POINTS - 1)
			var _y := task.y * (NewMapChunk.GENERATION_POINTS - 1)
			
			for xx in range(_x, _x + NewMapChunk.GENERATION_POINTS):
				for yy in [_y, _y + NewMapChunk.GENERATION_POINTS - 1]:
					var letter_key := Vector2i(xx, yy)
					if not letters.has(letter_key):
						letters[letter_key] = GeneratorTile.new(xx, yy)
					
			update_neighbours(letters[Vector2i(_x + 1, _y)])
			update_neighbours(letters[Vector2i(_x + 1, _y + NewMapChunk.GENERATION_POINTS - 1)])
				
			for yy in range(_y, _y + NewMapChunk.GENERATION_POINTS):
				for xx in [_x, _x + NewMapChunk.GENERATION_POINTS - 1]:
					var letter_key := Vector2i(xx, yy)
					if not letters.has(letter_key):
						letters[letter_key] = GeneratorTile.new(xx, yy)
					
			update_neighbours(letters[Vector2i(_x, _y + 1)])
			update_neighbours(letters[Vector2i(_x + NewMapChunk.GENERATION_POINTS - 1, _y + 1)])
			
			for xx in range(_x, _x + NewMapChunk.GENERATION_POINTS):
				for yy in range(_y, _y + NewMapChunk.GENERATION_POINTS):
					var letter_key := Vector2i(xx, yy)
					if not letters.has(letter_key):
						letters[letter_key] = GeneratorTile.new(xx, yy)
				#for yy in range(_y, _y + NewMapChunk.GENERATION_POINTS):
					#var letter_key := Vector2i(xx, yy)
					#if not letters.has(letter_key):
						#letters[letter_key] = GeneratorTile.new(xx, yy)
			#pass
		#print(letters)
		var id := WorkerThreadPool.add_group_task(worker_func, len(cur_tasaks))
		WorkerThreadPool.wait_for_group_task_completion(id)
		#if coords_untyped is Vector2i:
			#var coords := coords_untyped as Vector2i
		#
			#var _x := coords.x * (NewMapChunk.GENERATION_POINTS - 1)
			#var _y := coords.y * (NewMapChunk.GENERATION_POINTS - 1)
			#
			#for xx in range(_x, _x + NewMapChunk.GENERATION_POINTS):
				#for yy in range(_y, _y + NewMapChunk.GENERATION_POINTS):
					#var letter_key := Vector2i(xx, yy)
					#if not letters.has(letter_key):
						#letters[letter_key] = GeneratorTile.new(xx, yy)
			## offset by 1 as edge letters can have all 4 neighbours already done if it's 4th tile in a corner
			#update_neighbours(letters[Vector2i(_x + 1, _y + 1)])
			#var tile_terrain_corners := calculate_tile_terrain_corners(Vector2i(_x, _y))
			##var patterns := calculate_layers(tile_terrain_corners)
			#var chunk_data := calculate_chunk_data(tile_terrain_corners)
			#all_tasks[coords] = chunk_data
#
			#publish_chunk.emit.call_deferred(coords, chunk_data)
#func add_task(coords: Vector2i) -> void:
	#if tasks.has(coords):
		#return
		#
	#var fff := func() -> void:
		#var _x := coords.x * (NewMapChunk.GENERATION_POINTS - 1)
		#var _y := coords.y * (NewMapChunk.GENERATION_POINTS - 1)
		#
		#for xx in range(_x, _x + NewMapChunk.GENERATION_POINTS):
			#for yy in range(_y, _y + NewMapChunk.GENERATION_POINTS):
				#var letter_key := Vector2i(xx, yy)
				#if not letters.has(letter_key):
					#letters[letter_key] = GeneratorTile.new(xx, yy)
		## offset by 1 as edge letters can have all 4 neighbours already done if it's 4th tile in a corner
		#update_neighbours(letters[Vector2i(_x + 1, _y + 1)])
		#var tile_terrain_corners := calculate_tile_terrain_corners(Vector2i(_x, _y))
		##var patterns := calculate_layers(tile_terrain_corners)
		#var chunk_data := calculate_chunk_data(tile_terrain_corners)
#
		#publish_chunk.emit.call_deferred(tasks[coords], coords, chunk_data)
	#var id := WorkerThreadPool.add_task(fff)
	#tasks[coords] = id
	
func add_tasks(ccooooo: Array[Vector2i]) -> void:
	for c in ccooooo:
		mutex.lock()
		if not all_tasks.has(c):
			all_tasks[c] = true
			tasks.push_back(c)
			#add_task(c)
		#elif all_tasks[c]:
			#publish_chunk.emit(c, all_tasks[c])
		mutex.unlock()

func calculate_tile_terrain_corners(coords: Vector2i) -> Array[PackedStringArray]:
	var tile_terrain_corners: Array[PackedStringArray] = []
	for x in range(coords.x, coords.x + NewMapChunk.GENERATION_POINTS - 1):
		var top_row: PackedStringArray = []
		var bottom_row: PackedStringArray = []
		for y in range(coords.y, coords.y + NewMapChunk.GENERATION_POINTS - 1):
			
			@warning_ignore_start("return_value_discarded")
			top_row.push_back(letters[Vector2i(x, y)].selected_option)
			top_row.push_back(get_stronger_terrain([letters[Vector2i(x, y)],letters[Vector2i(x, y + 1)]]))
			bottom_row.push_back(get_stronger_terrain([letters[Vector2i(x, y)],letters[Vector2i(x + 1, y)]]))
			bottom_row.push_back(get_stronger_terrain([letters[Vector2i(x, y)],letters[Vector2i(x + 1, y)], letters[Vector2i(x, y + 1)], letters[Vector2i(x + 1, y + 1)]]))
			@warning_ignore_restore("return_value_discarded")
			
		# we generate 2n - 1 size array and need to insert last elements manually
		
		@warning_ignore_start("return_value_discarded")
		top_row.push_back(letters[Vector2i(x, coords.y + NewMapChunk.GENERATION_POINTS - 1)].selected_option)
		bottom_row.push_back(get_stronger_terrain([letters[Vector2i(x, coords.y + NewMapChunk.GENERATION_POINTS - 1)], letters[Vector2i(x + 1, coords.y + NewMapChunk.GENERATION_POINTS - 1)]]))
		@warning_ignore_restore("return_value_discarded")
		
		tile_terrain_corners.push_back(top_row)
		tile_terrain_corners.push_back(bottom_row)
	
	# we generate 2n - 1 size array and need to insert last row with last elements manually
	var last_row: PackedStringArray = []
	for y in range(coords.y, coords.y + NewMapChunk.GENERATION_POINTS - 1):
		@warning_ignore_start("return_value_discarded")
		last_row.push_back(letters[Vector2i(coords.x + NewMapChunk.GENERATION_POINTS - 1, y)].selected_option)
		last_row.push_back(get_stronger_terrain([letters[Vector2i(coords.x + NewMapChunk.GENERATION_POINTS - 1, y)], letters[Vector2i(coords.x + NewMapChunk.GENERATION_POINTS - 1, y + 1)]]))
		@warning_ignore_restore("return_value_discarded")
	
	@warning_ignore("return_value_discarded")
	last_row.push_back(letters[Vector2i(coords.x + NewMapChunk.GENERATION_POINTS - 1, coords.y + NewMapChunk.GENERATION_POINTS - 1)].selected_option)
	
	tile_terrain_corners.push_back(last_row)
	
	return tile_terrain_corners
	
func get_stronger_terrain(terrains: Array[GeneratorTile]) -> String:
	var acc := ""
	var power := -1
	for terrain in terrains:
		if PRIO[terrain.selected_option] > power:
			acc = terrain.selected_option
			power = PRIO[terrain.selected_option]
			
	return acc

#func calculate_layers(tile_terrain_corners: Array[PackedStringArray]) -> Array[TileMapPattern]:
	#var patterns: Array[TileMapPattern] = []
	#for ter in TERRAIN_OPTIONS:
		#var layer := TileMapPattern.new()
		#layer.set_size(Vector2i(TILE_COUNT, TILE_COUNT))
		#for x in range(0, TILE_COUNT):
			#for y in range(0, TILE_COUNT):
				#if tile_terrain_corners[x][y] != ter and tile_terrain_corners[x + 1][y] != ter and tile_terrain_corners[x][y + 1] != ter and tile_terrain_corners[x + 1][y + 1] != ter:
					#continue
				#var a := convert_terrain(tile_terrain_corners[x][y], ter)
				#var b := convert_terrain(tile_terrain_corners[x + 1][y], ter)
				#var c := convert_terrain(tile_terrain_corners[x][y + 1], ter)
				#var d := convert_terrain(tile_terrain_corners[x + 1][y + 1], ter)
				#var total := a + b * 2 + c * 8 + d * 4 - 1
				#layer.set_cell(Vector2i(x, y), 0, Vector2i(total, ORIGINS[ter]), 0)
		#
		#patterns.push_back(layer)
	#
	#return patterns

func calculate_chunk_data(tile_terrain_corners: Array[PackedStringArray]) -> NewMapChunkData:
	var chunk_data := NewMapChunkData.new()
	var packed_byte_array := PackedByteArray([0, 0, 0, 0])
	for x in range(0, NewMapChunk.TILE_COUNT):
		for y in range(0, NewMapChunk.TILE_COUNT):
			#print(Vector2i(x, y))
			var tile_data := 0
			for terrain_index in range(4):
				var ter := TERRAIN_OPTIONS[terrain_index]
				if tile_terrain_corners[x][y] != ter and tile_terrain_corners[x + 1][y] != ter and tile_terrain_corners[x][y + 1] != ter and tile_terrain_corners[x + 1][y + 1] != ter:
					continue
				var a := convert_terrain(tile_terrain_corners[x][y], ter)
				var b := convert_terrain(tile_terrain_corners[x + 1][y], ter)
				var c := convert_terrain(tile_terrain_corners[x][y + 1], ter)
				var d := convert_terrain(tile_terrain_corners[x + 1][y + 1], ter)
				
				# encoding index of tile in atlas using corners as binary counters
				tile_data += (a + b * 2 + c * 8 + d * 4) << (terrain_index * 6)
				
				#print(ter)
				#print(a + b * 2 + c * 8 + d * 4 - 1)
				
				# order of terrains can be dynamic
				# for now following current hardcoded order 
				tile_data += PRIO[ter] << (4 + (terrain_index * 6))
				
			#print("-=-=-=-=-=-=-")
			packed_byte_array.encode_u32(0, tile_data)
			
			chunk_data.tiles.push_back(NewMapChunkTileData.new(Vector2i(x, y), Color(packed_byte_array.decode_float(0), 0, 0, 0)))
			
	return chunk_data
	
func convert_terrain(source: String, target: String) -> int:
	return 1 if PRIO[source] >= PRIO[target] else 0

func add_half_of_weights(generator_tile: GeneratorTile, terrain: String) -> void:
	generator_tile.weights[terrain] += 5.0 / generator_tile.weights[terrain]
	#generator_tile.weights[terrain] += 5.0 / generator_tile.weights[terrain] + Utils.reduce(generator_tile.weights.values(), func(acc, cur): return acc + cur, 0) / 2

func select_weighted_random(weights: Dictionary[String, float]) -> String:
	var r := weights.r
	var rd := r + weights.d
	var rdg := rd + weights.g
	var rdgs := rdg + weights.s
	
	var rnd := randf_range(0, rdgs)
	
	if rnd <= r:
		return "r"
	elif rnd <= rd:
		return "d"
	elif rnd <= rdg:
		return "g"
	else:
		return "s"

# consider keeping one line of letters unassigned to have border with some weights in them

func update_neighbours(generator_tile: GeneratorTile, force: bool = false) -> void:
	if !generator_tile.selected_option:
		generator_tile.selected_option = select_weighted_random(generator_tile.weights)
	elif not force:
		return
		
	#generator_tile.selected_option = select_weighted_random(generator_tile.weights)
	
	var top_key := Vector2i(generator_tile.x, generator_tile.y - 1)
	var bottom_key := Vector2i(generator_tile.x, generator_tile.y + 1)
	var left_key := Vector2i(generator_tile.x - 1 , generator_tile.y)
	var right_key := Vector2i(generator_tile.x + 1, generator_tile.y)
	
	var top := letters[top_key] if letters.has(top_key) else null
	var bottom := letters[bottom_key] if letters.has(bottom_key) else null
	var left := letters[left_key] if letters.has(left_key) else null
	var right := letters[right_key] if letters.has(right_key) else null
	
	if top:
		if !top.selected_option:
			add_half_of_weights(top, generator_tile.selected_option)
			
	if bottom:
		if !bottom.selected_option:
			add_half_of_weights(bottom, generator_tile.selected_option)
			
	if left:
		if !left.selected_option:
			add_half_of_weights(left, generator_tile.selected_option)
			
	if right:
		if !right.selected_option:
			add_half_of_weights(right, generator_tile.selected_option)
	
	# doing in such order to make generation breadth first and not depth first
	
	var neighbours: Array[String] = []
	
	if top:
		if !top.selected_option:
			update_neighbours(top)
		neighbours.push_back(top.selected_option)
	if bottom:
		if !bottom.selected_option:
			update_neighbours(bottom)
		neighbours.push_back(bottom.selected_option)
	if left:
		if !left.selected_option:
			update_neighbours(left)
		neighbours.push_back(left.selected_option)
	if right:
		if !right.selected_option:
			update_neighbours(right)
		neighbours.push_back(right.selected_option)
	
	if generator_tile.selected_option not in neighbours:
		generator_tile.selected_option = neighbours.pick_random()
