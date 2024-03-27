extends BaseUnit

class_name Player

@onready var speed_to_damage_timer: Timer = $SpeedToDamageTimer
var game_state: GameState

func _ready():
	super._ready()
	game_state = get_parent().get_node("GameState")

func reset():
	hp = max_hp

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)
	
	var speed_multiplier = game_state.speed_during_fight if game_state.fighting else 1.0
	
	if !game_state.fighting:
		game_state.move_speed_from_acceleration += game_state.acceleration * delta
	else:
		game_state.move_speed_from_acceleration -= game_state.move_speed_from_acceleration / 20 * delta
		
	game_state.modified_move_speed = (game_state.current_move_speed + game_state.move_speed_from_acceleration) * speed_multiplier
	
	game_state.distance += game_state.modified_move_speed * delta
	

func _on_speed_to_damage_timer_timeout():
	if game_state.fighting:
		unit_attacking.emit(game_state.modified_move_speed * game_state.speed_to_damage_multiplier)


func _on_fight_scene_encounter_started():
	speed_to_damage_timer.start()
	if game_state.speed_impact > 0:
		get_tree().create_timer(0.15).timeout.connect(func(): unit_attacking.emit((game_state.current_move_speed + game_state.move_speed_from_acceleration) * game_state.speed_impact))

func _on_fight_scene_encounter_ended():
	speed_to_damage_timer.stop()
