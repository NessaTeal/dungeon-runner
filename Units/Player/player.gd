extends BaseUnit

class_name Player

@onready var movement_component: MovementComponent = $MovementComponent
@onready var trample_component: TrampleComponent = $TrampleComponent
@onready var slingshot_component: SlingshotComponent = $SlingshotComponent
@onready var immolation_component: ImmolationComponent = $ImmolationComponent

func _ready():
	super()
	components.merge({
		MovementComponent: movement_component,
		TrampleComponent: trample_component,
		SlingshotComponent: slingshot_component,
		ImmolationComponent: immolation_component
	})
