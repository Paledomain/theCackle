extends State
var death_timer: float = 0.0
@onready var gun_arm = $"../../gunArm"
@onready var player_death = $"../../PlayerDeath"


# Called when the node enters the scene tree for the first time.
func enter():
	super()
	death_timer = 0.0
	gun_arm.hide()
	print ("death started!")
	#play audio
	player_death.play()



func process_physics(delta: float) -> State:
	parent.velocity.y += gravity * delta
	parent.move_and_slide()
	#print(death_timer)
	if parent.health <= 0:
		#print(death_timer)
		death_timer += delta
		if(death_timer > 1):
			if(!parent.is_second_wind):
				parent.is_second_wind = true
				death_timer = 0
				#revive from below checkpoint
				parent.checkpoint_manager.revive()
				print("SECOND WIND!")
			else:
				parent.is_second_wind = false
				death_timer = 0
				#kill, back to start screen
				print("DEATH!")
				get_tree().reload_current_scene()
	return null
