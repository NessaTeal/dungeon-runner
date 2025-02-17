extends Node2D

class_name Chunk

static var SIZE = 10
var touched_tiles = {}

var nodes = []

# Tiles location in atlas is set using corners as binary counter
# 1 2
# 8 4
# Adding number together and subtracting one would give its location in atlas

@onready var rock: TileMapLayer = $Rock
@onready var dirt: TileMapLayer = $Dirt
@onready var sand: TileMapLayer = $Sand
@onready var grass: TileMapLayer = $Grass

static var PRIO = {"r": 0, "d": 1, "s": 2, "g": 3}
static var ORIGINS = {
	"r": 2,
	"d": 3,
	"s": 1,
	"g": 0
}

var layers = {}

var options = ["d", "r", "s", "g"]

var left = null
var right = null
var top = null
var bottom = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	layers = {
		"r": rock,
		"d": dirt,
		"s": sand,
		"g": grass
	}
	
	render_generated_chunk()
	
func generate_chunk():
	nodes = []
	for x in range(SIZE):
		nodes.push_back([])
		for y in range(SIZE):
			var tile = Tile.new(x, y)
			if x == 0 and left:
				tile.selected_option = left[y].selected_option
				tile.confidence = 5
			if y == 0 and top:
				tile.selected_option = top[x].selected_option
				tile.confidence = 5
			if x == SIZE - 1 and right:
				tile.selected_option = right[y].selected_option
				tile.confidence = 5
			if y == SIZE - 1 and bottom:
				tile.selected_option = bottom[x].selected_option
				tile.confidence = 5
			nodes[x].push_back(tile)
	
	if !left and !right and !top and !bottom:
		nodes[0][0].selected_option = options.pick_random()
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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

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

func render_generated_chunk():
	for x in range(1, SIZE):
		for y in range(1, SIZE):
			var points = [
				[
					nodes[x - 1][y - 1].selected_option,
				 	get_stronger_terrain([nodes[x - 1][y - 1],nodes[x - 1][y]]),
					nodes[x - 1][y].selected_option
				],
				[
				 	get_stronger_terrain([nodes[x - 1][y - 1],nodes[x][y - 1]]),
				 	get_stronger_terrain([nodes[x - 1][y - 1],nodes[x][y - 1], nodes[x - 1][y], nodes[x][y]]),
				 	get_stronger_terrain([nodes[x - 1][y],nodes[x][y]]),
				],
				[
				 	nodes[x][y - 1].selected_option,
				 	get_stronger_terrain([nodes[x][y - 1],nodes[x][y]]),
				 	nodes[x][y].selected_option
				]
			]
			
			for ter in options:
				for i in [0, 1]:
					for j in [0, 1]:
						if points[i][j] != ter and points[i + 1][j] != ter and points[i][j + 1] != ter and points[i + 1][j + 1] != ter:
							continue
						var a = convert_terrain(points[i][j], ter)
						var b = convert_terrain(points[i + 1][j], ter)
						var c = convert_terrain(points[i][j + 1], ter)
						var d = convert_terrain(points[i + 1][j + 1], ter)
						var total = a + b * 2 + c * 8 + d * 4
						layers[ter].set_cell(Vector2i((x - 1) * 2 + i, (y - 1) * 2 + j), 0, Vector2i(total - 1, ORIGINS[ter]))

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
	return Utils.reduce(terrains.map(func(x): return {"terrain": x.selected_option, "power": PRIO[x.selected_option]}),
	func(acc, cur): return acc if acc["power"] > cur["power"] else cur, {"power": -1})["terrain"]

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
