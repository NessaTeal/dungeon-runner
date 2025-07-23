extends Node

class_name ChunkGenerator

static var SIZE: int = 17
static var TILE_COUNT: int = (SIZE - 1) * 2
static var TILE_SIZE: int = 128
static var CHUNK_SIZE: int = TILE_COUNT * TILE_SIZE
static var CHUNK_SIZE_SQUARED: int = CHUNK_SIZE ** 2
static var MAP_TILE_SIZE: int = 100
static var MAP_TILE_SIZE_SQUARED: int = MAP_TILE_SIZE ** 2

var nodes: Array[Array] = []
var tile_terrain_corners = []
var patterns = []
var touched_tiles = {}

signal chunk_generated(x: int, y: int, chunk: Chunk)

# Tiles location in atlas is set using corners as binary counter
# 1 2
# 8 4
# Adding number together and subtracting one would give its location in atlas

@export var rock: TileMapLayer
@export var dirt: TileMapLayer
@export var sand: TileMapLayer
@export var grass: TileMapLayer
@onready var layers: Array[TileMapLayer] = [rock, dirt, sand, grass]

@export var sub_viewport: SubViewport

static var PRIO = {"r": 0, "d": 1, "s": 2, "g": 3}
static var ORIGINS = {
	"r": 2,
	"d": 3,
	"s": 1,
	"g": 0
}
static var TERRAIN_OPTIONS = ["d", "r", "s", "g"]

func reset():
	nodes = []
	tile_terrain_corners = []
	patterns = []
	touched_tiles = {}
	for layer in layers:
		layer.clear()

func generate_chunk(_x, _y, left, right, top, bottom):
	#reset()
	for x in range(SIZE):
		nodes.push_back([])
		for y in range(SIZE):
			var tile: GeneratorTile = GeneratorTile.new(x, y)
			if x == 0 and left:
				tile.selected_option = left[y]
				tile.confidence = 5
			if y == 0 and top:
				tile.selected_option = top[x]
				tile.confidence = 5
			if x == SIZE - 1 and right:
				tile.selected_option = right[y]
				tile.confidence = 5
			if y == SIZE - 1 and bottom:
				tile.selected_option = bottom[x]
				tile.confidence = 5
			nodes[x].push_back(tile)
	
	if !left and !right and !top and !bottom:
		nodes[0][0].selected_option = TERRAIN_OPTIONS.pick_random()
		update_neighbours(0, 0)
	else:
		for i in range(SIZE):
			if left:
				update_neighbours(0, i)
			if right:
				update_neighbours(SIZE - 1, i)
			if top:
				update_neighbours(i, 0)
			if bottom:
				update_neighbours(i, SIZE - 1)
	
	while !touched_tiles.is_empty():
		var nxt = find_biggest_weight()
		nxt.selected_option = select_weighted_random(nxt.weights)
		update_neighbours(nxt.x, nxt.y)
	
	calculate_confidence()
	
	calculate_tile_terrain_corners()
	
	calculate_layers()
	
	render_generated_chunk()
	
	await RenderingServer.frame_post_draw
	await RenderingServer.frame_post_draw
	
	#var t = sub_viewport.get_texture()
	var image = sub_viewport.get_texture().get_image()
	var thread = Thread.new()
	thread.start(func():
		#var image = t.get_image()
		#var image = viewport_texture.get_image()
		image.generate_mipmaps()
		#image.save_png("user://texture" + str(Time.get_unix_time_from_system()) + ".png")
		image.compress(Image.COMPRESS_S3TC)
		var texture = ImageTexture.create_from_image(image)
		var mapped_nodes = nodes.map(func(x_vector): return x_vector.map(func(node): return node.selected_option))
		return Chunk.new(mapped_nodes, texture))
		
	return await thread.wait_to_finish()
	#chunk_generated.emit(_x, _y, chunk)

func update_neighbours(x, y):
	var tile = nodes[x][y]
	
	if x > 0:
		var adj = nodes[x - 1][y]
		if !adj.selected_option:
			adj.add_half_of_weights(tile.selected_option)
			#adj.weights[tile.selected_option] += 1
			touched_tiles[adj] = true
		#if y > 0:
			#var adj2 = nodes[x - 1][y - 1]
			#if !adj2.selected_option:
				#adj2.add_half_of_weights(tile.selected_option)
				##adj2.weights[tile.selected_option] += 1
				#touched_tiles[adj2] = true
		#if y < SIZE - 1:
			#var adj2 = nodes[x - 1][y + 1]
			#if !adj2.selected_option:
				#adj2.add_half_of_weights(tile.selected_option)
				##adj2.weights[tile.selected_option] += 1
				#touched_tiles[adj2] = true
	if y > 0:
		var adj = nodes[x][y - 1]
		if !adj.selected_option:
			adj.add_half_of_weights(tile.selected_option)
			#adj.weights[tile.selected_option] += 1
			touched_tiles[adj] = true
		#if x < SIZE - 1:
			#var adj2 = nodes[x + 1][y - 1]
			#if !adj2.selected_option:
				#adj2.add_half_of_weights(tile.selected_option)
				##adj2.weights[tile.selected_option] += 1
				#touched_tiles[adj2] = true
	if x < SIZE - 1:
		var adj = nodes[x + 1][y]
		if !adj.selected_option:
			adj.add_half_of_weights(tile.selected_option)
			#adj.weights[tile.selected_option] += 1
			touched_tiles[adj] = true
		#if y < SIZE - 1:
			#var adj2 = nodes[x + 1][y + 1]
			#if !adj2.selected_option:
				#adj2.add_half_of_weights(tile.selected_option)
				##adj2.weights[tile.selected_option] += 1
				#touched_tiles[adj2] = true
	if y < SIZE - 1:
		var adj = nodes[x][y + 1]
		if !adj.selected_option:
			adj.add_half_of_weights(tile.selected_option)
			#adj.weights[tile.selected_option] += 1
			touched_tiles[adj] = true

func find_biggest_weight():
	var most_weight = -2
	var next_tile = null
	
	for tile in touched_tiles.keys():
		var wgth = tile.weights["r"] + tile.weights["d"] + tile.weights["g"] + tile.weights["s"]
		if wgth > most_weight:
			most_weight = wgth
			next_tile = tile
	
	touched_tiles.erase(next_tile)
	
	return next_tile
	
func calculate_tile_terrain_corners():
	for x in range(0, SIZE - 1):
		var top_row = []
		var bottom_row = []
		for y in range(0, SIZE - 1):
			
			top_row.push_back(nodes[x][y].selected_option)
			top_row.push_back(get_stronger_terrain([nodes[x][y],nodes[x][y + 1]]))
			bottom_row.push_back(get_stronger_terrain([nodes[x][y],nodes[x + 1][y]]))
			bottom_row.push_back(get_stronger_terrain([nodes[x][y],nodes[x + 1][y], nodes[x][y + 1], nodes[x + 1][y + 1]]))
		
		# we generate 2n - 1 size array and need to insert last elements manually
		top_row.push_back(nodes[x][SIZE - 1].selected_option)
		bottom_row.push_back(get_stronger_terrain([nodes[x][SIZE - 1], nodes[x + 1][SIZE - 1]]))
		
		tile_terrain_corners.push_back(top_row)
		tile_terrain_corners.push_back(bottom_row)
	
	# we generate 2n - 1 size array and need to insert last row with last elements manually
	var last_row = []
	for y in range(0, SIZE - 1):
		last_row.push_back(nodes[SIZE - 1][y].selected_option)
		last_row.push_back(get_stronger_terrain([nodes[SIZE - 1][y], nodes[SIZE - 1][y + 1]]))
	last_row.push_back(nodes[SIZE - 1][SIZE - 1].selected_option)
	
	tile_terrain_corners.push_back(last_row)

func calculate_layers():
	for ter in TERRAIN_OPTIONS:
		var layer = TileMapPattern.new()
		layer.set_size(Vector2i(TILE_COUNT, TILE_COUNT))
		for x in range(0, TILE_COUNT):
			for y in range(0, TILE_COUNT):
				if tile_terrain_corners[x][y] != ter and tile_terrain_corners[x + 1][y] != ter and tile_terrain_corners[x][y + 1] != ter and tile_terrain_corners[x + 1][y + 1] != ter:
					continue
				var a = convert_terrain(tile_terrain_corners[x][y], ter)
				var b = convert_terrain(tile_terrain_corners[x + 1][y], ter)
				var c = convert_terrain(tile_terrain_corners[x][y + 1], ter)
				var d = convert_terrain(tile_terrain_corners[x + 1][y + 1], ter)
				var total = a + b * 2 + c * 8 + d * 4 - 1
				layer.set_cell(Vector2i(x, y), 0, Vector2i(total, ORIGINS[ter]), 0)
		
		patterns.push_back(layer)

func render_generated_chunk():
	for layer_index in len(patterns):
		var pattern: TileMapPattern = patterns[layer_index]
		
		layers[layer_index].set_pattern(Vector2i(0, 0), pattern)
		

func calculate_confidence():
	for x in range(SIZE):
		for y in range(SIZE):
			var node = nodes[x][y]
			
			if node.confidence == 5:
				continue
			
			var nbh = 0
			
			if x > 0:
				var adj = nodes[x - 1][y]
				nbh += 1 if adj.selected_option == node.selected_option else 0
			if y > 0:
				var adj = nodes[x][y - 1]
				nbh += 1 if adj.selected_option == node.selected_option else 0
			if x < SIZE - 1:
				var adj = nodes[x + 1][y]
				nbh += 1 if adj.selected_option == node.selected_option else 0
			if y < SIZE - 1:
				var adj = nodes[x][y + 1]
				nbh += 1 if adj.selected_option == node.selected_option else 0
			
			node.confidence = nbh
	
	for x in range(SIZE):
		for y in range(SIZE):
			var node = nodes[x][y]
			
			var options = []
			var incomfidentOptions = []
			
			if node.confidence == 0:
				if x > 0:
					var adj = nodes[x - 1][y]
					incomfidentOptions.push_back(adj.selected_option)
					if adj.confidence != 0:
						options.push_back(adj.selected_option)
				if y > 0:
					var adj = nodes[x][y - 1]
					incomfidentOptions.push_back(adj.selected_option)
					if adj.confidence != 0:
						options.push_back(adj.selected_option)
				if x < SIZE - 1:
					var adj = nodes[x + 1][y]
					incomfidentOptions.push_back(adj.selected_option)
					if adj.confidence != 0:
						options.push_back(adj.selected_option)
				if y < SIZE - 1:
					var adj = nodes[x][y + 1]
					incomfidentOptions.push_back(adj.selected_option)
					if adj.confidence != 0:
						options.push_back(adj.selected_option)
				
				if options.is_empty():
					node.selected_option = incomfidentOptions.pick_random()
				else:
					node.selected_option = options.pick_random()
				node.confidence = 5

func convert_terrain(source, target):
	return 1 if PRIO[source] >= PRIO[target] else 0
	
func get_stronger_terrain(terrains):
	var acc = ""
	var power = -1
	for terrain in terrains:
		if PRIO[terrain.selected_option] > power:
			acc = terrain.selected_option
			power = PRIO[terrain.selected_option]
			
	return acc
	#return Utils.reduce(terrains.map(func(x): return {"terrain": x.selected_option, "power": PRIO[x.selected_option]}),
	#func(acc, cur): return acc if acc["power"] > cur["power"] else cur, {"power": -1})["terrain"]

func select_weighted_random(weights):
	var r = weights.r
	var rd = r + weights.d
	var rdg = rd + weights.g
	var rdgs = rdg + weights.s
	
	var rnd = randi_range(1, rdgs)
	
	if rnd <= r:
		return "r"
	elif rnd <= rd:
		return "d"
	elif rnd <= rdg:
		return "g"
	else:
		return "s"
