extends BaseUnit
class_name Player

@export var speed_component: SpeedComponent
@export var trample_component: TrampleComponent
@export var slingshot_component: SlingshotComponent
@export var immolation_component: ImmolationComponent
@export var direction_component: DirectionComponent
@export var movement_component: MovementComponent

@onready var all_components: Array[Node] = find_children("*Component")

signal player_position_updated(position: Vector2, direction: Vector2)

func report_player_position() -> void:
	player_position_updated.emit(get_2d_position(), direction_component.get_dir())

func reset() -> void:
	for component in all_components:
		# handle it better than string check and implicit logic that component has reset()
		if "reset" in component:
			component.reset()
