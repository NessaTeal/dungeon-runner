extends BaseUnit

class_name Player

@onready var speed_to_damage_timer: Timer = $SpeedToDamageTimer

@onready var movement_component: MovementComponent = $MovementComponent
@onready var fighting_component: FightingComponent = $FightingComponent

#func _on_speed_to_damage_timer_timeout():
	#if game_state.fighting:
		#pass
		#unit_attacking.emit(game_state.modified_move_speed * game_state.speed_to_damage_multiplier)


#func _on_fight_scene_encounter_started():
	#encounter_started.emit()
	#speed_to_damage_timer.start()
	#if game_state.speed_impact > 0:
		#pass
		#get_tree().create_timer(0.15).timeout.connect(func(): unit_attacking.emit((game_state.current_move_speed + game_state.move_speed_from_acceleration) * game_state.speed_impact))

#func _on_fight_scene_encounter_ended():
	#speed_to_damage_timer.stop()
