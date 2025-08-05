extends CanvasLayer

@export var game_holder: Node
@export var progress_bar: ProgressBar
@export var deero_sprite: AnimatedSprite2D

func tile_requested(_arg: Vector2i) -> void:
	progress_bar.max_value += 1
	
func tile_created() -> void:
	progress_bar.value += 1
	deero_sprite.position += Vector2((1/progress_bar.max_value) * progress_bar.size.x, 0)
	if progress_bar.value == progress_bar.max_value:
		visible = false
		game_holder.process_mode = Node.PROCESS_MODE_INHERIT
		queue_free()
