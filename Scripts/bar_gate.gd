extends RigidBody2D
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var collision_shape_2d = $CollisionShape2D

@export var countdown: float = 3
var counter: float = 0
@export var is_closed: bool = true
var anim_started: bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !anim_started and is_closed and  counter >= countdown:
		animated_sprite_2d.play("default")
		anim_started = true
	
	if is_closed and collision_shape_2d.position.y <= 0:
		counter += delta
		#print (counter)
		if counter >= countdown:
			collision_shape_2d.position.y += (counter - countdown) * 5
			
			
			
