extends BaseUnit

class_name Player

@onready var speed_component: SpeedComponent = $SpeedComponent
@onready var trample_component: TrampleComponent = $TrampleComponent
@onready var slingshot_component: SlingshotComponent = $SlingshotComponent
#@onready var immolation_component: ImmolationComponent = $ImmolationComponent
@onready var direction_component: DirectionComponent = $DirectionComponent
@onready var movement_component: MovementComponent = $MovementComponent

func _ready():
	super()
	components.merge({
		SpeedComponent: speed_component,
		TrampleComponent: trample_component,
		SlingshotComponent: slingshot_component,
		#ImmolationComponent: immolation_component,
		DirectionComponent: direction_component,
		MovementComponent: movement_component
	})
