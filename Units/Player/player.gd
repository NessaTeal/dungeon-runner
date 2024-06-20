extends BaseUnit

class_name Player

@onready var speed_to_damage_timer: Timer = $SpeedToDamageTimer
var game_state: GameState

signal encounter_started

func _ready():
	game_state = get_parent().get_node("GameState") as GameState
	super._ready()

	if game_state.immolate > 0:
		var immolation = preload("res://Perks/Effects/immolation.tscn").instantiate()
		encounter_started.connect(immolation._on_encounter_started)
		add_child(immolation)

	if game_state.retaliate > 0:
		var retaliate_effect = preload("res://Perks/Effects/retaliate_effect.tscn").instantiate()
		#unit_attacked.connect(retaliate_effect._on_unit_attacked)
		add_child(retaliate_effect)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var speed_multiplier = game_state.speed_during_fight if game_state.fighting else 1.0
	
	if !game_state.fighting:
		game_state.move_speed_from_acceleration += game_state.acceleration * delta
	else:
		game_state.move_speed_from_acceleration -= game_state.move_speed_from_acceleration / 20 * delta
		
	game_state.modified_move_speed = (game_state.current_move_speed + game_state.move_speed_from_acceleration) * speed_multiplier
	
	game_state.distance += game_state.modified_move_speed * delta
	

func _on_speed_to_damage_timer_timeout():
	if game_state.fighting:
		pass
		#unit_attacking.emit(game_state.modified_move_speed * game_state.speed_to_damage_multiplier)


func _on_fight_scene_encounter_started():
	encounter_started.emit()
	speed_to_damage_timer.start()
	if game_state.speed_impact > 0:
		pass
		#get_tree().create_timer(0.15).timeout.connect(func(): unit_attacking.emit((game_state.current_move_speed + game_state.move_speed_from_acceleration) * game_state.speed_impact))

func _on_fight_scene_encounter_ended():
	speed_to_damage_timer.stop()
