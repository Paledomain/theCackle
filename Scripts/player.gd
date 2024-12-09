class_name Player
extends CharacterBody2D
var facing_right: bool = true
var is_shoulder_swapped: bool = false
@onready
var animations = $animations
@onready
var gunArm = $gunArm

@onready
var state_machine = $state_machine

@export
var reload_dur: float = 1
@onready
var time_since_shoot: float = reload_dur
@export
var health: float = 4
@export
var damageCooldown: float = 1
@onready
var time_since_damaged = damageCooldown +5

var is_second_wind: bool = false

@export var checkpoint_manager: Node2D

@export var camera_2d: Camera2D
@export var randomStr: float = 30.0
@export var shakeFade: float = 2.0

@export var spawn_state: State
@export var hurt_state: State

@export var mouse_pos: Vector2

var rng = RandomNumberGenerator.new()
var shakeStr: float = 0.0
var shakeCooldown: float = 0.0

var is_pushing: bool = false
var moving_right: bool = true

var was_on_floor: bool = true

func _ready() -> void:
	# Initialize the state machine, passing a reference of the player to the states,
	# that way they can move and react accordingly
	state_machine.init(self)
	time_since_damaged = damageCooldown
	
func respawn() -> void:
	state_machine.change_state(spawn_state)
	health = 4

func damage(damage: float) -> void:
	if time_since_damaged >= damageCooldown:
		health -= damage
		time_since_damaged = 0
		state_machine.change_state(hurt_state)

func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

func _physics_process(delta: float) -> void:
	if time_since_damaged <= damageCooldown:
		time_since_damaged += delta
	#print(is_pushing)
	moving_right = !animations.flip_h
	
	gunArm.look_at(get_global_mouse_position())
	mouse_pos = get_global_mouse_position()
	if mouse_pos.x > position.x && gunArm.flip_v:
		gunArm.flip_v = false
	elif mouse_pos.x <= position.x && !gunArm.flip_v:
		gunArm.flip_v = true	
	
	if !animations.flip_h:
		facing_right = true
	elif animations.flip_h:
		facing_right = false
	
	if !facing_right:#left
		#gunArm.flip_h = true
		if !is_shoulder_swapped:
			gunArm.position.x += 10
			is_shoulder_swapped = true
	elif facing_right: #right
		gunArm.flip_h = false
		if is_shoulder_swapped:
			gunArm.position.x -= 10
			is_shoulder_swapped = false
	

	
	state_machine.process_physics(delta)
	#print(shakeCooldown)
	if  shakeCooldown >= 0:
		apply_shake()
		if shakeStr > 0:
			camera_2d.offset = random_offset()
			shakeStr = lerpf(shakeStr, 0, shakeFade * delta)
		shakeCooldown -= delta



func _process(delta: float) -> void:
	state_machine.process_frame(delta)

func load_sfx(sfx):
	if $PlayerSfx.stream != sfx:
		$PlayerSfx.stop()
		$PlayerSfx.stream = sfx

func apply_shake():
	#shakeStr = randomStr
	shakeStr = 2

func random_offset()-> Vector2:
	return Vector2(rng.randf_range(-shakeStr, shakeStr),rng.randf_range(-shakeStr, shakeStr))
