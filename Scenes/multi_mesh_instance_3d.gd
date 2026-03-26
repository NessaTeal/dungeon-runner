extends MultiMeshInstance3D

var full_count := 1103
var packed_byte_array := PackedByteArray([0,0,0,0])
#var orders := [3, 2, 1, 0]

var all_orders: Array[PackedInt32Array] = [
	PackedInt32Array([0, 1, 2, 3]),
	PackedInt32Array([0, 1, 3, 2]),
	PackedInt32Array([0, 2, 1, 3]),
	PackedInt32Array([0, 2, 3, 1]),
	PackedInt32Array([0, 3, 1, 2]),
	PackedInt32Array([0, 3, 2, 1]),
	PackedInt32Array([1, 0, 2, 3]),
	PackedInt32Array([1, 0, 3, 2]),
	PackedInt32Array([1, 2, 0, 3]),
	PackedInt32Array([1, 2, 3, 0]),
	PackedInt32Array([1, 3, 0, 2]),
	PackedInt32Array([1, 3, 2, 0]),
	PackedInt32Array([2, 0, 1, 3]),
	PackedInt32Array([2, 0, 3, 1]),
	PackedInt32Array([2, 1, 0, 3]),
	PackedInt32Array([2, 1, 3, 0]),
	PackedInt32Array([2, 3, 0, 1]),
	PackedInt32Array([2, 3, 1, 0]),
	PackedInt32Array([3, 0, 1, 2]),
	PackedInt32Array([3, 0, 2, 1]),
	PackedInt32Array([3, 1, 0, 2]),
	PackedInt32Array([3, 1, 2, 0]),
	PackedInt32Array([3, 2, 0, 1]),
	PackedInt32Array([3, 2, 1, 0])
]
	
func _ready() -> void:
	multimesh.instance_count = full_count * full_count
	
	#var float_test:float = 1.0
	#
	#var arr = PackedByteArray([0, 0, 0b10000000, 0x3F]) 
	#print(arr.decode_float(0))\
	self.position = Vector3(-1.0 * full_count / 2, 0, -1.0 * full_count / 2)
	get_parent().get_node("Camera3D").position = Vector3(position.x, 20, position.z)
	
	for x in range(full_count):
		for z in range(full_count):
			var current_instance := x * full_count + z
			var order: PackedInt32Array = all_orders[(current_instance % 50625) % 24]
			multimesh.set_instance_transform(current_instance, Transform3D(Basis(), Vector3(x * 1.0, 0, z * 1.0)))
			#multimesh.set_instance_color((x + half_count) * full_count + (z + half_count), Color(randf(), randf(), randf()))
			#var intt = randi() % 15
			var tile_data := 0
			#orders.shuffle()
			for tile_data_index in range(4):
				@warning_ignore("integer_division")
				tile_data += (1 + ((current_instance / (floori(pow(15, tile_data_index)))) % 15)) << (tile_data_index * 6)
				#print(current_instance)
				#print(tile_data_index * 4)
				#print((current_instance >> (tile_data_index * 4)))
				#print((current_instance >> (tile_data_index * 4)) % 15)
				#print(((current_instance >> (tile_data_index * 4)) % 15) << (tile_data_index * 6))
				#print(tile_data)
				tile_data += order[tile_data_index] << (4 + (tile_data_index * 6))
				#var grass_tile := (current_instance % 15)
				#var grass_order := orders[0] << 4
				#var sand_tile := (current_instance / 15)
				#var sand_order := orders[1]
			#@warning_ignore("integer_division")
			packed_byte_array.encode_u32(0, tile_data)
			#packed_byte_array.reverse() # uint and float have different endians for some reason
			multimesh.set_instance_custom_data(current_instance, Color(packed_byte_array.decode_float(0),0,0,0))
			#var d := PackedByteArray([0, 0, 0, 0 + ((current_instance) << 1)]).decode_float(0)
			#tarr.encode_float(0,d)
			#print("===")
			#print(current_instance)
			#print("===")
			#print(PackedByteArray([0, 0, 0, 0 + ((current_instance) << 1)]).decode_float(0))
			#print(tarr)
			#print(packed_byte_array)
			#packed_byte_array.reverse()
			#print((packed_byte_array.decode_u32(0) >> 6) % 16)
			#print("===")
			#print("=")
			#print(((current_instance % 16) << 4) >> 4)
			#print((intt) << 4)
			#var b = PackedByteArray([255, 0, 0, 0]).decode_float(0)
			#print(b)

#func _process(delta: float) -> void:
	#for x in range(-half_count, half_count - 1):
		#for z in range(-half_count, half_count - 1):
			#multimesh.set_instance_transform((x + half_count) * full_count + (z + half_count), Transform3D(Basis(), Vector3(x * 2, 0, z * 2)))
			#multimesh.set_instance_color((x + half_count) * full_count + (z + half_count), Color(randf(), randf(), randf()))
