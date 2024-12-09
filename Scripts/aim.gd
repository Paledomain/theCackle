extends State
@onready var gun_arm = $"../../gunArm"
@onready var mouse = $"../../mouse"


@export
var fall_state: State
@export
var move_state: State
@export
var idle_state: State
@export
var fire_state: State
@export
var death_state: State

func enter() -> void:
	super()
	gun_arm.show()
	parent.velocity.x = 0
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	mouse.visible=true
	
	
func exit() -> void:
	super()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	mouse.visible=false
	

func process_input(event: InputEvent) -> State:
	if parent.time_since_shoot >= parent.reload_dur and Input.is_action_just_pressed('fire') and parent.is_on_floor():
		return fire_state
		
	if Input.is_action_just_released("aim") and (Input.is_action_just_pressed("move_left") or Input.is_action_just_pressed("move_right")):
		gun_arm.hide()
		return move_state
	elif Input.is_action_just_released("aim") and !(Input.is_action_just_pressed("move_left") or Input.is_action_just_pressed("move_right")):
		gun_arm.hide()
		return idle_state
	return null

func process_physics(delta: float) -> State:
	
	mouse.global_position = parent.mouse_pos
	
	parent.velocity.y += gravity * delta
	parent.move_and_slide()
	
	if parent.health <= 0:
		return death_state
	
	if !parent.is_on_floor():
		return fall_state
	return null
