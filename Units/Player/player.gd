extends CharacterBody3D
class_name Player

@export var speed_component: SpeedComponent
@export var trample_component: TrampleComponent
@export var slingshot_component: SlingshotComponent
@export var immolation_component: ImmolationComponent
@export var direction_component: DirectionComponent
@export var movement_component: MovementComponent
@export var health_component: HealthComponent
@export var attack_component: AttackComponent

@onready var all_components: Array[Node] = find_children("*Component")

signal player_position_updated(position: Vector3, direction: Vector2)

func report_player_position() -> void:
	pass
	#player_position_updated.emit(position, direction_component.get_dir())

func reset() -> void:
	for component in all_components:
		# handle it better than string check and implicit logic that component has reset()
		if "reset" in component:
			component.reset()
