extends BasePerk

static func apply(game_state: GameState):
	game_state.player_hp_regen_from_missing_hp += 0.4
