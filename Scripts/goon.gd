class_name Goon
extends CharacterBody2D
var facing_right: bool = true
var is_shoulder_swapped: bool = false

@onready var animations = $animations
@onready var barrel = $animations/barrel

@onready
var state_machine = $state_machine
@onready var death_collision = $DeathCollision

@onready var aggro_range = $aggroRange/range
@onready var shoot_range = $shootRange/range
@onready var raycast = $RayCast2D

var right_contact: bool = true
var left_contact: bool = true

var player_in_aggro: bool = false
var player_in_shoot: bool = false

@export var move_speed = 100

@export
var fire_confirmed: bool = false
@export
var player_body: Player

@export
var reload_dur: float = 2
@onready
var time_since_shoot: float = reload_dur
@export
var health: float = 2
@export
var damageCooldown: float = 1
@onready
var time_since_damaged = damageCooldown

var is_second_wind: bool = false


@export var spawn_state: State
@export var hurt_state: State


func get_aggro_range() -> CollisionShape2D:
	return aggro_range
func get_shoot_range() -> CollisionShape2D:
	return shoot_range
func get_raycast() -> RayCast2D:
	return raycast	


func _on_aggro_range_body_entered(body):
	if body is Player:
		player_in_aggro = true
		player_body = body

func _on_aggro_range_body_exited(body):
	if body is Player:
		player_in_aggro = false


func _on_shoot_range_body_entered(body):
	if body is Player:
		player_in_shoot = true
		player_body = body


func _on_shoot_range_body_exited(body):
	if body is Player:
		player_in_shoot = false



func _ready() -> void:
	# Initialize the state machine, passing a reference of the player to the states,
	# that way they can move and react accordingly
	state_machine.init(self)
	time_since_damaged = damageCooldown
	death_collision.disabled = true
	

func damage(damage: float) -> void:
	#if time_since_damaged >= damageCooldown:
	if health > 0:
		health -= damage
		time_since_damaged = 0
		state_machine.change_state(hurt_state)
		#print (health)
	

#func _unhandled_input(event: InputEvent) -> void:
#	state_machine.process_input(event)

func _physics_process(delta: float) -> void:
	raycast.target_position = raycast.to_local(player_body.position)
	
	if time_since_shoot <= damageCooldown:
		time_since_shoot += delta
	
	if time_since_damaged <= damageCooldown:
		time_since_damaged += delta
		
	if player_in_aggro and player_in_shoot:
		velocity.x = 0
		#print ("body entered!")
		
		animations.flip_h = raycast.target_position.x < 0
		#print(raycast.to_local(body.position))
		#print(raycast.target_position)
		if raycast.is_colliding() and raycast.get_collider() == player_body:
			#print ("is colliding")
			if raycast.target_position.x < -40:
				#print ("target position x = " + str(raycast.target_position.x))
				fire_confirmed = true
			elif raycast.target_position.x > 40:
				#print ("target position x = " + str(raycast.target_position.x))
				fire_confirmed = true
			else:
				fire_confirmed = false
			
	
	elif player_in_aggro and !player_in_shoot and is_on_floor():
		raycast.target_position = raycast.to_local(player_body.position)
		animations.flip_h = raycast.target_position.x < 0
		if !animations.flip_h and right_contact and left_contact:
			velocity.x = move_speed
		elif animations.flip_h and left_contact and right_contact:
			velocity.x = -move_speed
		elif !right_contact or !left_contact:
			velocity.x = 0
		

	
	state_machine.process_physics(delta)
	#print(shakeCooldown)



func _process(delta: float) -> void:
	state_machine.process_frame(delta)


func _on_floor_col_right_area_exited(area):
	right_contact = false
	#print("exit right")
func _on_floor_col_right_area_entered(area):
	right_contact = true

func _on_floor_col_left_area_exited(area):
	left_contact = false
	#print("exit left")
func _on_floor_col_left_area_entered(area):
	left_contact = true
