extends BaseAffix

func apply(game_state: GameState):
	game_state.player_hp_regen_from_missing_hp += power / 25.0
