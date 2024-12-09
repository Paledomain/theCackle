extends State
@onready var player_land_short = $"../../PlayerLandShort"


@export
var idle_state: State
@export
var move_state: State
@export
var fall_state: State

var time_since_start: float = 0.0
var ground_check: bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	time_since_start = 0.0

func enter():
	super()
	parent.modulate = Color(1.2,1.5,1,1)
	parent.velocity.x = 0
	
func process_physics(delta: float) -> State:
	time_since_start += delta
	
	if parent.is_on_floor() and !ground_check:
		player_land_short.playing = true
		ground_check = true

	if(time_since_start > 1):
		time_since_start = 0.0
		if parent.is_on_floor():
			return idle_state	
			
		if !parent.is_on_floor():
			return fall_state
	parent.velocity.y += gravity * delta
	parent.move_and_slide()
	return null
