extends Node

var player: Player
var game_state: GameState

func _ready():
	player = get_parent()
	game_state = player.game_state

func _on_unit_attacked(damage: float):
	player.unit_attacking.emit(damage * game_state.retaliate)
