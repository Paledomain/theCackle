extends Area2D
@onready var light = $PointLight2D
@onready var animation = $animation
@onready var click = $click

@export var inactive: Color
@export var active: Color
var is_active: bool = false

@export var energyMax: float = 3
@export var energyMin: float = 1
var is_decreasing: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	is_active = false
	light.color = inactive


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if !is_decreasing:
		if light.energy <= energyMax:
			is_decreasing = false
			light.energy += delta
		elif light.energy > energyMax:
			is_decreasing = true
			light.energy -= delta
	elif is_decreasing:
		if light.energy >= energyMin:
			is_decreasing = true
			light.energy -= delta
		elif light.energy < energyMin:
			is_decreasing = false
			light.energy += delta 

func _on_body_entered(body):
	animation.play("boop")
	click.play()
	light.color = active
	is_active = true
