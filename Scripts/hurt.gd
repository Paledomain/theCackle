extends State
@onready var gun_arm = $"../../gunArm"
var hurt_timer: float = 0.0
@export var flash: Color
@export var standart: Color
@export var normalise: Color
@onready var player_hurt = $"../../PlayerHurt"

@export
var idle_state: State
@export
var death_state: State


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func enter():
	super()
	gun_arm.hide()
	hurt_timer = 0
	parent.modulate = flash
	print ("hurt!")
	#play audio
	player_hurt.play()
	

	


func process_physics(delta: float) -> State:
	if parent.health <= 0:
		return death_state
	var movement = Input.get_axis('move_left', 'move_right') * move_speed / 3
	parent.velocity.x = movement
	parent.velocity.y += gravity * delta
	parent.move_and_slide()
	hurt_timer += delta
	#print(hurt_timer)
	if parent.modulate.g > standart.g:
		parent.modulate -= normalise / 20
	if hurt_timer >= parent.damageCooldown and parent.health > 0:
		parent.modulate = standart
		return idle_state
	return null
