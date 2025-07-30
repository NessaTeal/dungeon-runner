extends CanvasLayer

@export var game_holder: Node

func tile_requested(_arg):
	$ProgressBar.max_value += 1
	
func tile_created():
	$ProgressBar.value += 1
	$AnimatedSprite2D.position += Vector2((1/$ProgressBar.max_value) * $ProgressBar.size.x, 0)
	if $ProgressBar.value == $ProgressBar.max_value:
		#get_parent().process_mode = Node.PROCESS_MODE_INHERIT
		visible = false
		game_holder.process_mode = Node.PROCESS_MODE_INHERIT
		queue_free()
