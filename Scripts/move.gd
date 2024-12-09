extends State
@onready var collision_shape_2d = $"../../CollisionShape2D"
@onready var player_move = $"../../PlayerMove"
@onready var animations = $"../../animations"




@export
var fall_state: State
@export
var idle_state: State
@export
var launch_state: State
@export
var aim_state: State
@export
var death_state: State
@export
var push_state: State

var leftBuffer: bool = false
var rightBuffer: bool = false

func enter() -> void:
	super()
	player_move.play()

func exit() -> void:
	super()
	player_move.stop()

func process_input(event: InputEvent) -> State:
	if Input.is_action_pressed("aim"):
		return aim_state
	else:
		if Input.is_action_just_pressed('jump') and parent.is_on_floor():
			return launch_state
	return null

func process_physics(delta: float) -> State:
	parent.velocity.y += gravity * delta
	
	if parent.health <= 0:
		return death_state
	if Input.is_action_pressed('move_left'):
		leftBuffer = true
	if Input.is_action_pressed('move_right'):
		rightBuffer = true
	
	var movement = Input.get_axis('move_left', 'move_right') * move_speed
	
	if movement == 0 && (!leftBuffer or !rightBuffer):
		return idle_state
	elif leftBuffer:
		leftBuffer = false
	elif rightBuffer:
		rightBuffer = false
		


	if parent.is_on_wall() and (Input.is_action_pressed('move_right') or Input.is_action_pressed('move_left')):	
		return push_state
			
	
	parent.velocity.x = movement
	parent.animations.flip_h = movement < 0
	
	
	parent.was_on_floor = parent.is_on_floor()
	parent.move_and_slide()
	
	
	if !parent.is_on_floor():
		return fall_state
	return null
