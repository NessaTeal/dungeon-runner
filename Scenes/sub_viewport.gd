@tool

extends SubViewport

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		get_texture()
