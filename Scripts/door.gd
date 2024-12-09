extends RigidBody2D

@onready var collision_shape_2d = $CollisionShape2D
@onready var light_occluder_2d = $LightOccluder2D
@onready var animated_sprite_2d = $AnimatedSprite2D
@export var player: Player

var door_open: bool = false
var door_counter: float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	#print(door_counter)
	if door_open:
		door_counter += delta
		collision_shape_2d.disabled = true
	elif !door_open:
		door_counter = 0
	if door_counter >= 2.1:
		collision_shape_2d.disabled = false
		light_occluder_2d.occluder_light_mask = 1
		door_open = false
		


func _on_area_2d_body_entered(body):
	#print ("body entered!")
	if body == player:
		#print ("is_player")
		#if player.is_pushing:
			#print ("is_pushing")
		door_open = true
		collision_shape_2d.disabled = true
		light_occluder_2d.occluder_light_mask = 10
		if player.moving_right:
			animated_sprite_2d.flip_h = false
			animated_sprite_2d.play("default")
		elif !player.moving_right:
			animated_sprite_2d.flip_h = true
			animated_sprite_2d.play("default")
