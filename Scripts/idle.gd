extends State


@export
var fall_state: State
@export
var launch_state: State
@export
var move_state: State
@export
var aim_state: State
@export
var long_state: State
@export
var death_state: State

@export var idle_timeout: float = 3.0  # time before switching to long idle
var time_since_longIdle: float = 0.0

func enter() -> void:
	super()
	parent.velocity.x = 0
	time_since_longIdle = 0

func process_input(event: InputEvent) -> State:
	
	if Input.is_action_pressed("aim"):
		return aim_state
	else:
		if Input.is_action_just_pressed('jump') and parent.is_on_floor():
			return launch_state
		if Input.is_action_just_pressed('crouch') and parent.is_on_floor():
			parent.position.y += 10
		if Input.is_action_just_pressed('move_left') or Input.is_action_just_pressed('move_right'):
			return move_state
	return null

func process_physics(delta: float) -> State:
	time_since_longIdle += delta
	
	if parent.health <= 0:
		return death_state
	
	if time_since_longIdle > idle_timeout:
		return long_state	
	
	parent.velocity.y += gravity * delta
	parent.was_on_floor = parent.is_on_floor()
	parent.move_and_slide()

	
	if !parent.is_on_floor():
		return fall_state
	return null
