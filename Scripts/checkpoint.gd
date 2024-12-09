extends Area2D

@onready var particles = $GPUParticles2D
@onready var heal_particles = $HealParticles
@onready var light = $PointLight2D
@onready var birth_pt = $birthPt
@onready var woaw = $woaw

@export var activeColour: Color
@export var button: Area2D
@export var infiniteRespawn: bool = false

var is_active: bool = false

func _ready():
	is_active = false
	particles.emitting = false
	light.hide()


func _process(delta):
	if button.is_active == true:
		is_active = true
		particles.emitting = true
		light.show()
		light.color = activeColour
		modulate = activeColour
		
func getRespawnPosition():
	return birth_pt.get_global_position()

func _on_body_entered(body):
	if is_active and body.has_method("damage"):
		heal_particles.emitting = true
		body.health = 4
		woaw.play()
