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
var death_state: State


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


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
	parent.was_on_floor = parent.is_on_floor()
	parent.move_and_slide()

		
	if parent.health <= 0:
		return death_state
	
	if !parent.is_on_floor():
		return fall_state
	return null
