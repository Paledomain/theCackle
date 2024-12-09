extends State

@export
var fall_state: State
@export
var land_state: State
#for jump charge calculation
@export
var launch_state: State
@export
var death_state: State

@export
var jump_force: float = 300.0

func enter() -> void:
	super()
	var charge = launch_state.launchCharge 
	parent.velocity.y = -jump_force* charge

func process_physics(delta: float) -> State:
	parent.velocity.y += gravity * delta
	
	if parent.velocity.y > 0:
		return fall_state
	
	if parent.health <= 0:
		return death_state
	
	var movement = Input.get_axis('move_left', 'move_right') * move_speed
	
	if movement != 0:
		parent.animations.flip_h = movement < 0
	parent.velocity.x = movement
	parent.move_and_slide()
	
	if parent.is_on_floor():
		return land_state
	
	return null
