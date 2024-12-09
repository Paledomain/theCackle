extends State


@export
var fall_state: State
@export
var move_state: State
@export
var launch_state: State
@export
var aim_state: State
@export
var death_state: State



func enter():
	super()
	

func exit():
	super()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func process_input(event: InputEvent) -> State:
	if Input.is_action_pressed("aim"):
		return aim_state
	else:
		if Input.is_action_just_pressed('jump') and parent.is_on_floor():
			return launch_state
		if Input.is_action_just_pressed('move_left') or Input.is_action_just_pressed('move_right'):
			return move_state
	return null
	
func process_physics(delta: float) -> State:
	parent.velocity.y += gravity * delta
	parent.velocity.x = 0
	parent.move_and_slide()
	
	if parent.is_on_floor() and parent.velocity.x != 0:
		return move_state
	elif !parent.is_on_floor():
		return fall_state
		
	
	return null
	
