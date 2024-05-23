extends BasePerk

static func apply(game_state: GameState):
	game_state.immolate_storage += 0.5
