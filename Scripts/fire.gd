extends State
@export var BulletSpeed: float = 700.0
@onready var barrel = $"../../gunArm/Barrel"
@export var bullet: PackedScene
@onready var gun_arm = $"../../gunArm"
@onready var gun = $"../../gunArm/Gun"
@onready var player_gun = $"../../PlayerGun"


@export
var fall_state: State
@export
var idle_state: State
@export
var move_state: State
@export
var aim_state: State




func shoot(direction: Vector2):
	#play shoot audio
	player_gun.play()
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
	parent.velocity.x = 0
	parent.shakeCooldown = parent.shakeFade
	gun_arm.play("shoot")
	gun_arm.play("reload")

func process_input(event: InputEvent) -> State:
	if Input.is_action_just_released("aim") and (Input.is_action_just_pressed("move_left") or Input.is_action_just_pressed("move_right")):
		gun_arm.hide()
		return move_state
	elif Input.is_action_just_released("aim") and !(Input.is_action_just_pressed("move_left") or Input.is_action_just_pressed("move_right")):
		gun_arm.hide()
		return idle_state
	return aim_state

func process_physics(delta: float) -> State:
	if parent.time_since_shoot >= parent.reload_dur:
		shoot((barrel.global_position-gun.global_position).normalized())
	return null
