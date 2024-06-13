extends BaseAffix

func apply(game_state: GameState):
	game_state.current_move_speed += power / 10.0
