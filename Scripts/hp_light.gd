extends PointLight2D

@export var energyMin: float = 1
@export var energyMax: float = 3
var is_decreasing: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _physics_process(delta):
	if !is_decreasing:
		if energy <= energyMax:
			is_decreasing = false
			energy += 5*delta
		elif energy > energyMax:
			is_decreasing = true
			energy -= 5*delta
	elif is_decreasing:
		if energy >= energyMin:
			is_decreasing = true
			energy -= 5*delta
		elif energy < energyMin:
			is_decreasing = false
			energy += 5*delta 
