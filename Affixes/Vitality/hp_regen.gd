extends BaseAffix

func get_value():
	return power / 25.0

func apply(game_state: GameState):
	game_state.player_hp_regen_from_missing_hp += get_value()
