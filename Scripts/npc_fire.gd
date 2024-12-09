extends State
@export var BulletSpeed: float = 700.0
@export var bullet: PackedScene
@onready var barrel = $"../../animations/barrel"
@onready var animations = $"../../animations"
@onready var goon_boom = $"../../goonBoom"



@export
var idle_state: State
@export
var move_state: State

var shoot_target: Vector2
var is_shoulder_swapped: bool

var animation_dur: float = 0


func shoot(direction: Vector2):
	#play audio
	goon_boom.play()
	# Instantiate the bullet
	var bullet_instance = bullet.instantiate()
	# Set the bullet's position to the hand's position
	bullet_instance.look_at(direction) 
	# Set the bullet's rotation to face the direction
	bullet_instance.position = barrel.global_position
	# Set the bullet's velocity
	bullet_instance.velocity = direction * BulletSpeed
	# Add the bullet to the scene
	get_parent().add_child(bullet_instance)
	parent.time_since_shoot = 0



func enter() -> void:
	super()
	animation_dur = 0
	parent.velocity.x = 0
	print("fire state!")
	if animations.flip_h:
		barrel.position.x = -17
		is_shoulder_swapped = true
	elif !animations.flip_h:
		barrel.position.x = 17
		is_shoulder_swapped = false
	animations.play("fire")


func process_physics(delta: float) -> State:
	animation_dur += delta
	parent.velocity.x = 0
	parent.velocity.y += gravity * delta
	parent.move_and_slide()
	
	shoot_target = parent.player_body.global_position
	#print ("time since shoot: " + str(parent.time_since_shoot))
	if animations.flip_h: #left
		#print("Is shoulder swapped?: " + str(is_shoulder_swapped))
		if !is_shoulder_swapped:
			barrel.position.x = 17
			is_shoulder_swapped = true
	elif !animations.flip_h: #right
		if is_shoulder_swapped:
			barrel.position.x = -17
			is_shoulder_swapped = false
	if parent.get_raycast().target_position.y < -35:
		barrel.position.y = -17
	elif parent.get_raycast().target_position.y >= -35:
		barrel.position.y = 5
	
	
	if parent.time_since_shoot >= parent.reload_dur and parent.get_raycast().is_colliding() and animation_dur >= 0.6:
		#print(parent.player_body.global_position)
		shoot((parent.to_local(shoot_target)).normalized())
		shoot((parent.to_local(shoot_target)).normalized().rotated(deg_to_rad(-10)))
		shoot((parent.to_local(shoot_target)).normalized().rotated(deg_to_rad(-5)))
		

	
	elif animation_dur >= 1.1:
		return idle_state
	return null
