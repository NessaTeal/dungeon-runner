extends BaseAffix

func get_value():
	return power / 200.0

func apply(game_state: GameState):
	game_state.speed_during_fight += get_value()
