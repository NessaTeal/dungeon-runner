extends BaseAffix

func apply(game_state: GameState):
	game_state.player_hp += power * 2
