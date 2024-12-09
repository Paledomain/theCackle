extends State
var death_timer: float = 0.0
@onready var collision_shape_2d = $"../../CollisionShape2D"
@onready var death_collision = $"../../DeathCollision"
var is_dead: bool
@onready var goon_death = $"../../goonDeath"


# Called when the node enters the scene tree for the first time.
func enter():
	super()
	death_timer = 0.0
	is_dead = false
	print ("death started!")
	#play audio
	goon_death.play()



func process_physics(delta: float) -> State:
	parent.velocity.y += gravity * delta
	parent.velocity.x = parent.velocity.x/2
	parent.move_and_slide()
	#print(death_timer)
	if parent.health <= 0:
		#print(death_timer)
		death_timer += delta
		if(death_timer > 1):
			is_dead = true

			death_collision.disabled = false
			collision_shape_2d.disabled = true
	if (death_timer > 3 and is_dead):
				print("NPC DEATH!")
				parent.queue_free()
	return null
