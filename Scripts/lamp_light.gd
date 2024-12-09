extends PointLight2D

@export var energyMax: float = 3
@export var energyMin: float = 1
var is_decreasing = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !is_decreasing:
		if energy <= energyMax:
			is_decreasing = false
			energy += delta
		elif energy > energyMax:
			is_decreasing = true
			energy -= delta
	elif is_decreasing:
		if energy >= energyMin:
			is_decreasing = true
			energy -= delta
		elif energy < energyMin:
			is_decreasing = false
			energy += delta
	
