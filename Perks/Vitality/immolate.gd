extends BasePerk

static func apply(game_state: GameState):
	game_state.immolate += 0.1 / 20.0 # attack happens 20 times a second
