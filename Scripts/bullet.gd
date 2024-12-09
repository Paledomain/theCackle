extends Area2D

@onready var raycast: RayCast2D = $RayCast2D

var velocity: Vector2 = Vector2.ZERO
var has_bounced: bool = false # Track if the bullet has already bounced
@export var explosion_scene: PackedScene


@export var explosion_name: String = "maxiBoom"
@export var explosion_particle: int = 1
@export var target = 4

func _physics_process(delta: float) -> void:
	
	rotation = velocity.angle()
	# Check if the raycast is colliding
	if raycast.is_colliding():
		explode(explosion_name)
		
		queue_free()
	# Move the bullet

	position += velocity * delta

# Optional: Handle collision to free the bullet if it hits something



func explode(animName) -> void:
	# Instance the explosion and add it to the scene
	var explosion = explosion_scene.instantiate()
	explosion.position = position
	
	get_parent().add_child(explosion)
	explosion.target = target
	explosion.get_child(0).play(animName)
	explosion.get_child(explosion_particle).emitting = true
	explosion.get_child(explosion_particle).process_material.set_direction(Vector3(-velocity.normalized().x, -velocity.normalized().y, 0))
	

#==================================================
# SmoothLookAt Function
#==================================================
#    SmoothLookAtRigid -> Call from integrate_forces()
#    SmoothLookAt for KinematicBody2D -> Call from _physics_process()
#    SmoothLookAt for Node2D -> Call from _process()
#    ----------
#    nodeToTurn = the node you want to turn
#    targetPosition = the Vector2 you want your nodeToTurn to face
#    turnSpeed = how quickly nodeToTurn will turn to face the direction you want it to face
#    ----------
#    X+ is assumed to be forward, the face/nose of your object

func SmoothLookAt( nodeToTurn, targetPosition, turnSpeed ):
	nodeToTurn.rotate( deg_to_rad( AngularLookAt( nodeToTurn.global_position, nodeToTurn.global_rotation, targetPosition, turnSpeed ) ) )

func SmoothLookAtRigid( nodeToTurn, targetPosition, turnSpeed ):
	nodeToTurn.angular_velocity = AngularLookAt( nodeToTurn.global_position, nodeToTurn.global_rotation, targetPosition, turnSpeed )

#-------------------------
# these are only called from above functions
func AngularLookAt( currentPosition, currentRotation, targetPosition, turnTime ):
	return GetAngle( currentRotation, TargetAngle( currentPosition, targetPosition ) )/turnTime
	
func TargetAngle( currentPosition, targetPosition ):
	return (targetPosition - currentPosition).angle()
	
func GetAngle( currentAngle, targetAngle ):
	return fposmod( targetAngle - currentAngle + PI, PI * 2 ) - PI
