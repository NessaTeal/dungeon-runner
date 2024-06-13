extends BaseAffix

func apply(game_state: GameState):
	game_state.speed_impact += power / 20.0
