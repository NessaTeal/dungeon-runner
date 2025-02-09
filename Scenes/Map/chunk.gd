extends TileMapLayer

var tiles = []
static var SIZE = 8
var touched_tiles = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	restart()
	
	#while true:
		#var stuff = find_smallest_entropy()
		#
		#var entropy = stuff.options.size()
		#
		#if entropy == 0:
			#restart()
			#continue
		#
		#if entropy == 9999:
			#break
			#
		#var x = stuff.x
		#var y = stuff.y
		#
		#stuff.selected_option = stuff.options.pick_random()
		#self.set_cell(Vector2i(x, y), 2, stuff.selected_option.atlas_position)
		#update_neighbours(x, y)
		
	#for x in range(SIZE):
		#for y in range(SIZE):
			#self.set_cell(Vector2i(x, y), 2, tiles[x][y].selected_option.atlas_position)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var next_tile = find_smallest_entropy()
	#print(touched_tiles)
	#print(next_tile.x)
	#print(next_tile.y)
	
	if next_tile == null:
		return
		
	if next_tile.options.size() == 0:
		restart()
		return
	
	next_tile.selected_option = next_tile.options.pick_random()
	self.set_cell(Vector2i(next_tile.x, next_tile.y), 2, next_tile.selected_option.atlas_position)
	update_neighbours(next_tile.x, next_tile.y)
	#print(touched_tiles)
	#set_process(false)

func update_neighbours(x, y):
	var tile = tiles[x][y]
	
	if x > 0:
		var adj = tiles[x - 1][y]
		if adj.selected_option.is_empty():
			var possibilities = adj.options
			var result = []
			for option in possibilities:
				if tile.selected_option["left"] == option["right"].reverse():
					result.push_back(option)
			adj.options = result
			touched_tiles[adj] = true
	if y > 0:
		var adj = tiles[x][y - 1]
		if adj.selected_option.is_empty():
			var possibilities = adj.options
			var result = []
			for option in possibilities:
				if tile.selected_option["top"] == option["bottom"].reverse():
					result.push_back(option)
			adj.options = result
			touched_tiles[adj] = true
	if x < SIZE - 1:
		var adj = tiles[x + 1][y]
		if adj.selected_option.is_empty():
			var possibilities = adj.options
			var result = []
			for option in possibilities:
				if tile.selected_option["right"] == option["left"].reverse():
					result.push_back(option)
			adj.options = result
			touched_tiles[adj] = true
	if y < SIZE - 1:
		var adj = tiles[x][y + 1]
		if adj.selected_option.is_empty():
			var possibilities = adj.options
			var result = []
			for option in possibilities:
				if tile.selected_option["bottom"] == option["top"].reverse():
					result.push_back(option)
			adj.options = result
			touched_tiles[adj] = true

func find_smallest_entropy():
	var least_entropy = 9999
	var next_tile = null
	
	for tile in touched_tiles.keys():
		if tile.options.size() < least_entropy:
			least_entropy = tile.options.size()
			next_tile = tile
	
	touched_tiles.erase(next_tile)
	
	return next_tile

func restart():
	touched_tiles = {}
	tiles = []
	for x in range(SIZE):
		tiles.push_back([])
		for y in range(SIZE):
			self.set_cell(Vector2i(x, y))
			tiles[x].push_back(Tile.new(x, y))
	
	tiles[0][0].selected_option = tiles[0][0].options.pick_random()
	self.set_cell(Vector2i(0, 0), 2, tiles[0][0].selected_option.atlas_position)
	update_neighbours(0, 0)
