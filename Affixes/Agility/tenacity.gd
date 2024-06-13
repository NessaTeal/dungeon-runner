extends BaseAffix

func apply(game_state: GameState):
	game_state.speed_during_fight += power / 200.0
