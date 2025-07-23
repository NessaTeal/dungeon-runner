extends Node2D

func _ready() -> void:
	await RenderingServer.frame_post_draw
	get_viewport().get_texture().get_image().save_exr("user://raw_" + str(Time.get_unix_time_from_system()) + ".exr")
