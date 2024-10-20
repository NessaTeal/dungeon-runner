extends Control
class_name SlingshotComponent

@export var attack_component: AttackComponent
@export var movement_component: SpeedComponent

var slingshot_projectile_script = preload("res://Units/Components/Slingshot/slingshot_projectile.tscn")

var coefficient = 0

func perform_bonk():
	var damage = movement_component.current_speed * coefficient
	if damage > 0:
		var projectile = slingshot_projectile_script.instantiate()
		projectile.damage = damage
		projectile.attack_component = attack_component
		add_child(projectile)

func reset():
	coefficient = 0
