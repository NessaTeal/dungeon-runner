extends Node
class_name DirectionComponent

var direction: float = 0
@export var turn_rate: float = PI / 3
@export var player: Player

static var quarter_pi = PI / 4
static var three_quarter_pi = quarter_pi * 3
static var one_and_quarter_pi = quarter_pi * 5
static var one_and_three_quarter_pi = quarter_pi * 7


func get_dir():
	return Vector2.DOWN.rotated(direction)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#direction.x = 1
	#direction.y = 0
	#if Input.is_action_pressed("GoUp"):
		#direction.y = -1
	#elif Input.is_action_pressed("GoDown"):
		#direction.y = 1
	#else:
		#direction.y = 0
	
	var delta_turn = turn_rate * delta
	
	if Input.is_action_pressed("GoLeft"):
		direction -= delta_turn
	elif Input.is_action_pressed("GoRight"):
		direction += delta_turn
		
	direction = fposmod(direction, TAU)
	
	#var sprite_direction: Vector2
	#var small_angle: float = direction
	
	#if direction > (quarter_pi + quarter_pi):
		#if direction > (one_and_quarter_pi + quarter_pi):
			#player.play("down")
			#sprite_direction = Vector2.DOWN
		#else:
			#player.play("up")
			#sprite_direction = Vector2.UP
			#small_angle -= PI
	#else:
		#player.play("down")
		#sprite_direction = Vector2.DOWN
	
	#if direction > quarter_pi:
		#if direction > three_quarter_pi:
			#if direction > one_and_quarter_pi:
				#if direction > one_and_three_quarter_pi:
					#player.play("down")
					#sprite_direction = Vector2.DOWN
				#else:
					#player.play("right")
					#sprite_direction = Vector2.RIGHT
					#small_angle -= (three_quarter_pi + three_quarter_pi)
			#else:
				#player.play("up")
				#sprite_direction = Vector2.UP
				#small_angle -= PI
		#else:
			#player.play("left")
			#sprite_direction = Vector2.LEFT
			#small_angle -= (quarter_pi + quarter_pi)
	#else:
		#player.play("down")
		#sprite_direction = Vector2.DOWN
	
	#player.set_global_rotation(small_angle)
	player.set_global_rotation(Vector3(0, -direction, 0))
