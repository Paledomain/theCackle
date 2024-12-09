extends State
@onready var player_land_short = $"../../PlayerLandShort"

@export
var land_state: State
@export
var move_state: State
@export
var launch_state: State
@export
var death_state: State

var fall_duration: float = 0.0
var dust = preload("res://Scenes/dustFX.tscn")

func instDust(pos):
	var instance = dust.instantiate()
	instance.position = pos
	#instance.velocity = Vector2(parent.velocity.x, -parent.velocity.y)
	add_child(instance)


func process_physics(delta: float) -> State:
	parent.velocity.y += gravity * delta
	fall_duration += delta

	var movement = Input.get_axis('move_left', 'move_right') * move_speed

	if movement != 0:
		parent.animations.flip_h = movement < 0
	parent.velocity.x = movement
	parent.move_and_slide()
	
	if parent.health <= 0:
		return death_state
	
	if parent.is_on_floor() and fall_duration > 0.4:
		instDust(parent.position)
		fall_duration = 0
		
		return land_state
	elif parent.is_on_floor() and fall_duration <= 0.4 and !Input.is_action_just_pressed("jump"):
		instDust(parent.position)
		fall_duration = 0
		player_land_short.play()
		return move_state
	elif parent.is_on_floor() and fall_duration <= 0.4 and Input.is_action_just_pressed("jump"):
		instDust(parent.position)
		fall_duration = 0
		player_land_short.play()
		return launch_state
	return null
