extends BaseAffix

func get_value():
	return (power / 100.0 * 3.0) / 4.0 # attack happens 4 times a second

func apply(game_state: GameState):
	game_state.speed_to_damage_multiplier += get_value()
