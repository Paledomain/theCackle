extends State
@onready var goon_move = $"../../goonMove"

@export
var death_state: State
@export
var idle_state: State
@export
var fire_state: State

func enter() -> void:
	super()
	goon_move.play()

func exit() -> void:
	super()
	goon_move.stop()


func process_physics(delta: float) -> State:
	parent.velocity.y += gravity * delta
	parent.move_and_slide()
	if parent.velocity.x == 0:
		return idle_state
	if parent.fire_confirmed and parent.time_since_shoot >= parent.reload_dur:
		return fire_state
	if parent.health <= 0:
		#print("enter death!")
		return death_state
	return null
