extends State
@onready var coyote_timer = $"../../coyoteTimer"

@export
var jump_state: State

@export
var fall_state: State
@export
var death_state: State

var launchCharge: float = 1

func enter() -> void:
	super()
	parent.velocity.x = 0
	launchCharge = 1

func process_input(event: InputEvent) -> State:
	if parent.is_on_floor() or !coyote_timer.is_stopped():
		return jump_state
	return null

func process_physics(delta: float) -> State:
	launchCharge += delta
	parent.velocity.x == 0
	parent.velocity.y += gravity * delta
	
	parent.was_on_floor = parent.is_on_floor()
	parent.move_and_slide()
	
	if parent.was_on_floor and !parent.is_on_floor():
		coyote_timer.start()
	
	if parent.health <= 0:
		return death_state
	
	if !parent.is_on_floor():
		return fall_state
	return null
