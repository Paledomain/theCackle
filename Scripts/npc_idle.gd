extends State



@export
var move_state: State
@export
var fire_state: State
@export
var death_state: State


@export var player:CharacterBody2D


# Called when the node enters the scene tree for the first time.
func enter() -> void:
	super()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func process_physics(delta: float) -> State:
	if parent.health <= 0:
		#print("enter death!")
		return death_state

	if parent.fire_confirmed and parent.time_since_shoot >= parent.reload_dur:
		return fire_state
	
	if parent.velocity.x != 0:
		return move_state
	
	parent.velocity.y += gravity * delta
	parent.move_and_slide()

	return null
	
		
