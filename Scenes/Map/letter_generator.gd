extends Node

class_name LetterGenerator

const chunk_generator_scene = preload("res://Scenes/Map/chunk_generator.tscn")
const tile_map_layer_scene = preload("res://Scenes/Map/tile_map_layer_scene.tscn")

var letters: Dictionary[Vector2i, GeneratorTile] = {}

static var SIZE: int = 9
static var TILE_COUNT: int = (SIZE - 1) * 2
static var TILE_SIZE: int = 128
static var CHUNK_SIZE: int = TILE_COUNT * TILE_SIZE
static var CHUNK_SIZE_SQUARED: int = CHUNK_SIZE ** 2

static var ORIGINS: Dictionary[String, int] = {
	"r": 2,
	"d": 3,
	"s": 1,
	"g": 0
}

static var TERRAIN_OPTIONS: Array[String] = ["d", "r", "s", "g"]

static var PRIO: Dictionary[String, int] = {"r": 0, "d": 1, "s": 2, "g": 3}

signal texture_ready(coords: Vector2i, texture: ImageTexture)

var tasks: Dictionary[Vector2i, Callable] = {}
		
var requested_chunks: Dictionary[Vector2i, bool] = {}

func remove_task(coords: Vector2i):
	if tasks.has(coords):
		tasks.erase(coords)

func add_task(coords: Vector2i):
	var task := get_task(coords)
	
	tasks[coords] = task
	
func get_task(coords: Vector2i) -> Callable:
	var _x := coords.x * (SIZE - 1)
	var _y := coords.y * (SIZE - 1)
	
	return func():
		for xx in range(_x, _x + SIZE):
			for yy in range(_y, _y + SIZE):
				var letter_key = Vector2i(xx, yy)
				if not letters.has(letter_key):
					letters[letter_key] = GeneratorTile.new(xx, yy)
		# offset by 1 as edge letters can have all 4 neighbours already done if it's 4th tile in a corner
		update_neighbours(letters[Vector2i(_x + 1, _y + 1)])
		var tile_terrain_corners := calculate_tile_terrain_corners(Vector2i(_x, _y))
		var patterns := calculate_layers(tile_terrain_corners)
	
		var chunk_generator := chunk_generator_scene.instantiate() as ChunkGenerator
		chunk_generator.setup(patterns)
		chunk_generator.chunk_generated.connect(
			func(texture: ImageTexture):
				texture_ready.emit.call_deferred(coords, texture))
		
		(func():
			add_child(chunk_generator)
			chunk_generator.render_generated_chunk(patterns)).call_deferred()

var task_id: int = -1

func _process(_delta: float) -> void:
	if task_id == -1:
		if not tasks.is_empty():
			var key = tasks.keys()[0]
			task_id = WorkerThreadPool.add_task(tasks[key])
			tasks.erase(key)
	elif WorkerThreadPool.is_task_completed(task_id):
		WorkerThreadPool.wait_for_task_completion(task_id)
		task_id = -1
	
func calculate_tile_terrain_corners(coords: Vector2i) -> Array[PackedStringArray]:
	var tile_terrain_corners: Array[PackedStringArray] = []
	for x in range(coords.x, coords.x + SIZE - 1):
		var top_row: PackedStringArray = []
		var bottom_row: PackedStringArray = []
		for y in range(coords.y, coords.y + SIZE - 1):
			
			top_row.push_back(letters[Vector2i(x, y)].selected_option)
			top_row.push_back(get_stronger_terrain([letters[Vector2i(x, y)],letters[Vector2i(x, y + 1)]]))
			bottom_row.push_back(get_stronger_terrain([letters[Vector2i(x, y)],letters[Vector2i(x + 1, y)]]))
			bottom_row.push_back(get_stronger_terrain([letters[Vector2i(x, y)],letters[Vector2i(x + 1, y)], letters[Vector2i(x, y + 1)], letters[Vector2i(x + 1, y + 1)]]))
		
		# we generate 2n - 1 size array and need to insert last elements manually
		top_row.push_back(letters[Vector2i(x, coords.y + SIZE - 1)].selected_option)
		bottom_row.push_back(get_stronger_terrain([letters[Vector2i(x, coords.y + SIZE - 1)], letters[Vector2i(x + 1, coords.y + SIZE - 1)]]))
		
		tile_terrain_corners.push_back(top_row)
		tile_terrain_corners.push_back(bottom_row)
	
	# we generate 2n - 1 size array and need to insert last row with last elements manually
	var last_row: PackedStringArray = []
	for y in range(coords.y, coords.y + SIZE - 1):
		last_row.push_back(letters[Vector2i(coords.x + SIZE - 1, y)].selected_option)
		last_row.push_back(get_stronger_terrain([letters[Vector2i(coords.x + SIZE - 1, y)], letters[Vector2i(coords.x + SIZE - 1, y + 1)]]))
	last_row.push_back(letters[Vector2i(coords.x + SIZE - 1, coords.y + SIZE - 1)].selected_option)
	
	tile_terrain_corners.push_back(last_row)
	
	return tile_terrain_corners
	
func get_stronger_terrain(terrains: Array[GeneratorTile]) -> String:
	var acc = ""
	var power = -1
	for terrain in terrains:
		if PRIO[terrain.selected_option] > power:
			acc = terrain.selected_option
			power = PRIO[terrain.selected_option]
			
	return acc

func calculate_layers(tile_terrain_corners: Array[PackedStringArray]) -> Array[TileMapPattern]:
	var patterns: Array[TileMapPattern] = []
	for ter in TERRAIN_OPTIONS:
		var layer = TileMapPattern.new()
		layer.set_size(Vector2i(TILE_COUNT, TILE_COUNT))
		for x in range(0, TILE_COUNT):
			for y in range(0, TILE_COUNT):
				if tile_terrain_corners[x][y] != ter and tile_terrain_corners[x + 1][y] != ter and tile_terrain_corners[x][y + 1] != ter and tile_terrain_corners[x + 1][y + 1] != ter:
					continue
				var a := convert_terrain(tile_terrain_corners[x][y], ter)
				var b := convert_terrain(tile_terrain_corners[x + 1][y], ter)
				var c := convert_terrain(tile_terrain_corners[x][y + 1], ter)
				var d := convert_terrain(tile_terrain_corners[x + 1][y + 1], ter)
				var total := a + b * 2 + c * 8 + d * 4 - 1
				layer.set_cell(Vector2i(x, y), 0, Vector2i(total, ORIGINS[ter]), 0)
		
		patterns.push_back(layer)
	
	return patterns

func convert_terrain(source, target) -> int:
	return 1 if PRIO[source] >= PRIO[target] else 0

func add_half_of_weights(generator_tile: GeneratorTile, terrain: String) -> void:
	generator_tile.weights[terrain] += 5.0 / generator_tile.weights[terrain]
	#generator_tile.weights[terrain] += 5.0 / generator_tile.weights[terrain] + Utils.reduce(generator_tile.weights.values(), func(acc, cur): return acc + cur, 0) / 2

func select_weighted_random(weights: Dictionary[String, float]):
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

func update_neighbours(generator_tile: GeneratorTile, force: bool = false):
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
	
	if top:
		if !top.selected_option:
			update_neighbours(top)
	if bottom:
		if !bottom.selected_option:
			update_neighbours(bottom)
	if left:
		if !left.selected_option:
			update_neighbours(left)
	if right:
		if !right.selected_option:
			update_neighbours(right)
	
