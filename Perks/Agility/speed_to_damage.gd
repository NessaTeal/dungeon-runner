extends BasePerk

static func apply(game_state: GameState):
	game_state.speed_to_damage_multiplier += 3.0 / 4 # attack happens 4 times a second
