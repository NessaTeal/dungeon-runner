extends BaseAffix

func get_value():
	return power / 10.0

func apply(game_state: GameState):
	game_state.acceleration += get_value()
	
