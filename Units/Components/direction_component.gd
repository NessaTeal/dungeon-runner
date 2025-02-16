extends Node
class_name DirectionComponent

var direction: Vector2 = Vector2.ONE :
	get:
		return direction.normalized()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#direction.x = 1
	#direction.y = 0
	if Input.is_action_pressed("GoUp"):
		direction.y = -1
	elif Input.is_action_pressed("GoDown"):
		direction.y = 1
	else:
		direction.y = 0
	
	if Input.is_action_pressed("GoLeft"):
		direction.x = -1
	elif Input.is_action_pressed("GoRight"):
		direction.x = 1
	else:
		direction.x = 0
