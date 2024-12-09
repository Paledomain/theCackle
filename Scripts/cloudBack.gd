extends ParallaxLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


@export var CLOUD_SPEED:float = 30.0

func _process(delta) -> void:
	self.motion_offset.x += CLOUD_SPEED * delta
