extends State
@onready var player_land = $"../../PlayerLand"


@export
var idle_state: State
@export
var move_state: State
@export
var fall_state: State
@export
var launch_state: State
@export
var death_state: State

var time_since_land: float = 0.0
var drag_stopped: bool = false

var dust = preload("res://Scenes/dustFX.tscn")

func enter():
	super()
	#play sound
	player_land.play()
func exit():
	super()
	#stop sound
	player_land.stop()

func instDust(pos):
	var instance = dust.instantiate()
	instance.position = pos
	#instance.velocity = Vector2(parent.velocity.x, -parent.velocity.y)
	add_child(instance)

func process_input(event: InputEvent) -> State:
	if drag_stopped && (Input.is_action_just_pressed('move_left') or Input.is_action_just_pressed('move_right')):
		return move_state
	return null

func process_physics(delta: float) -> State:
	instDust(parent.position)
	
	if parent.health <= 0:
		return death_state
	
	if parent.is_on_floor():
		if time_since_land < 0.6:
			drag_stopped = false
			time_since_land += delta
			parent.velocity.x -= delta
			parent.velocity.y += gravity * delta
		else:
			drag_stopped = true
			time_since_land = 0
			return idle_state
			
	parent.move_and_slide()
	if !parent.is_on_floor() or parent.velocity.y > 0:
		return fall_state
	return null
