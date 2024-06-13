extends BaseAffix

func get_value():
	return power / 20.0
	
func apply(game_state: GameState):
	game_state.speed_impact += get_value()
