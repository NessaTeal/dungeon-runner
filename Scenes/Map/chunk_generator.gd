extends Node

class_name ChunkGenerator

signal chunk_generated(texture: ImageTexture)
#
## Tiles location in atlas is set using corners as binary counter
## 1 2
## 8 4
## Adding number together and subtracting one would give its location in atlas
#

@export var sub_viewport: SubViewport

var task_id: int = -1
var tex: ImageTexture = null

func _process(_delta: float) -> void:
	if task_id != -1:
		if WorkerThreadPool.is_task_completed(task_id):
			WorkerThreadPool.wait_for_task_completion(task_id)
			chunk_generated.emit(tex)
			queue_free()

var scene = preload("res://Scenes/Map/tile_map_layer_scene.tscn")

func setup(patterns: Array[TileMapPattern]):
	for pattern in patterns:
		var layer: TileMapLayer = scene.instantiate()
		layer.set_pattern(Vector2i(0, 0), pattern)
		sub_viewport.add_child(layer)

func render_generated_chunk(_patterns: Array[TileMapPattern]):
	RenderingServer.request_frame_drawn_callback(func():
		var rendering_device = RenderingServer.get_rendering_device()
		var rid = sub_viewport.get_texture().get_rid()
		var rd_rid = RenderingServer.texture_get_rd_texture(rid)
		
		rendering_device.texture_get_data_async(rd_rid, 0, func(packed_array: PackedByteArray):
			task_id = WorkerThreadPool.add_task(func():
				var image = Image.create_from_data(2048, 2048, false, Image.FORMAT_RGBA8, packed_array)
				image.generate_mipmaps()
				tex = ImageTexture.create_from_image(image)))
		)
