extends Node2D
@onready var area = $Area2D
@export var damage = 2
@onready var collision_shape_2d = $Area2D/CollisionShape2D
@export var target = 2 #2 for player, 4 for enemy
@onready var area_2d = $Area2D
@export var boom_dur: float = 0.2
var boom_count: float

# Dictionary to keep track of damaged bodies
var damaged_bodies: Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	boom_count = 0
	damaged_bodies.clear()
	#area.set_collision_mask_value(2, false)
	#area.set_collision_mask_value(4, false)
	area.set_collision_mask_value(target, true)
	#print(area.collision_mask)



	
	
func _physics_process(delta):
	if boom_count <= boom_dur:
		boom_count += delta
		for body in area_2d.get_overlapping_bodies():
			if !damaged_bodies.has(body) and body.has_method("damage"):
				body.damage(damage)
				damaged_bodies[body] = true  # Mark this body as damaged
	elif boom_count > boom_dur:
		queue_free()
	
	#collision_shape_2d.disabled = true
