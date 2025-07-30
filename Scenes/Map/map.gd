extends Node3D
class_name Map

const default_texture := preload("res://Textures/terrain.png")

static var MAP_TILE_DRAW_DISTANCE := 13
static var MAP_TILE_DRAW_ANGLE := 50.0

static var MAP_TILE_SIZE: int = 100
#static var MAP_TILE_SIZE_SQUARED: int = MAP_TILE_SIZE ** 2

var textures_to_process: Dictionary[Vector2i, ImageTexture]

signal tile_created
signal tile_requested(position: Vector2i)
signal tile_cancelled(position: Vector2i)

var map_tiles: Dictionary[Vector2i, MeshInstance3D] = {}

func create_map_tile(coords: Vector2i, texture: ImageTexture) -> void:
	# check if tile was freed already
	if not map_tiles.has(coords):
		#print("Received map tile texture when it's already not needed")
		return
	var map_tile := map_tiles[coords]
	map_tile.mesh.material.albedo_texture = texture
	tile_created.emit()

func update_map(player_position: Vector2, player_direction: Vector2):
	var offset_player_position := player_position - 2 * player_direction * MAP_TILE_SIZE
	var discrete_player_position := (offset_player_position / MAP_TILE_SIZE).round()
	
	var direction_one := player_direction.rotated(deg_to_rad(MAP_TILE_DRAW_ANGLE))
	var direction_two := player_direction.rotated(deg_to_rad(-MAP_TILE_DRAW_ANGLE))
	
	var point_zero := (discrete_player_position + player_direction * MAP_TILE_DRAW_DISTANCE).round()
	var point_one := (discrete_player_position + direction_one * MAP_TILE_DRAW_DISTANCE).round()
	var point_two := (discrete_player_position + direction_two * MAP_TILE_DRAW_DISTANCE).round()
	
	var minumum_x := int(min(discrete_player_position.x, point_zero.x, point_one.x, point_two.x)) - 5
	var maximum_x := int(max(discrete_player_position.x, point_zero.x, point_one.x, point_two.x)) + 5
	var minimum_y := int(min(discrete_player_position.y, point_zero.y, point_one.y, point_two.y)) - 5
	var maximum_y := int(max(discrete_player_position.y, point_zero.y, point_one.y, point_two.y)) + 5
	
	var v1 := Vector2(point_two.y - discrete_player_position.y, discrete_player_position.x - point_two.x)
	var v2 := Vector2(point_zero.y - point_two.y, point_two.x - point_zero.x)
	var v3 := Vector2(point_one.y - point_zero.y, point_zero.x - point_one.x)
	var v4 := Vector2(discrete_player_position.y - point_one.y, point_one.x - discrete_player_position.x)
	
	var all_keys: Array[Vector2i] = []
	var tiles_to_request: Array[Vector2i] = []
	var tiles_to_remove: Array[Vector2i] = []
	
	for x in range(minumum_x, maximum_x):
		for y in range(minimum_y, maximum_y):
			var keyf := Vector2(x, y)
			var key := Vector2i(x, y)
			
			var vv1 := keyf - discrete_player_position
			if v1.dot(vv1) > 0:
				continue
			
			var vv2 := keyf - point_two
			if v2.dot(vv2) > 0:
				continue
			
			var vv3 := keyf - point_zero
			if v3.dot(vv3) > 0:
				continue
			
			var vv4 := keyf - point_one
			if v4.dot(vv4) > 0:
				continue
			
			all_keys.push_back(key)
			
			if not map_tiles.has(key):
				tiles_to_request.push_back(key)
				
	for key in map_tiles.keys():
		if !all_keys.has(key):
			tiles_to_remove.push_back(key)
			
	for key in tiles_to_request:
		var map_tile := MeshInstance3D.new()
		var plane_mesh := PlaneMesh.new()
		plane_mesh.size = Vector2(MAP_TILE_SIZE, MAP_TILE_SIZE)
		map_tile.mesh = plane_mesh
		var material := ORMMaterial3D.new()
		plane_mesh.surface_set_material(0, material)
		material.no_depth_test = true
		material.texture_repeat = false
		material.texture_filter = BaseMaterial3D.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS_ANISOTROPIC
		material.albedo_texture = default_texture
		map_tile.set_position(Vector3(key.x * MAP_TILE_SIZE, 0, key.y * MAP_TILE_SIZE))
		map_tiles[key] = map_tile
		add_child(map_tile)
		tile_requested.emit(key)
		
	for key in tiles_to_remove:
		map_tiles[key].queue_free()
		tile_cancelled.emit(key)
			
		map_tiles.erase(key)
