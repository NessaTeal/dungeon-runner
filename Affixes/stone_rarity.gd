extends Resource
class_name StoneRarity

@export var chance: float
@export var affix_count: int
@export var minimum_power: float
@export var maximum_power: float

func _init(p_chance: float = 70.0, p_affix_count: int = 1, p_minimum_power: float = 50.0, p_maximum_power: float = 65.0) -> void:
	self.chance = p_chance
	self.affix_count = p_affix_count
	self.minimum_power = p_minimum_power
	self.maximum_power = p_maximum_power
