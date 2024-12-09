extends Control

@export var player: Player

@onready var hp_bar = $hpBar
@onready var hp_bar_edge = $hpBar/hpBarEdge
@onready var hp_light = $hpBar/hpBarEdge/hpLight
@onready var hp_slot = $hpSlot
@onready var ap_1 = $AP1
@onready var timer = $hpBar/hpBarEdge/Timer

var bar_old


# Called when the node enters the scene tree for the first time.
func _ready():
	hp_bar_edge.play("default")
	hp_slot.play("default")
	bar_old = player.health


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if bar_old > player.health:
		bar_old -= delta * 10
	elif bar_old < player.health:
		bar_old += delta * 10
	hp_bar.value = bar_old
	barCalculate()
	if player.health == 0:
		hp_light.enabled = false
	else:
		hp_light.enabled = true


func barCalculate():
	# Calculate the filled width of the progress bar based on its value
	var filled_width = hp_bar.size.x * (hp_bar.value / hp_bar.max_value)
	
	# Set the AnimatedSprite position to the rightmost end of the filled width
	hp_bar_edge.position.x = hp_bar.position.x + filled_width - 9
	hp_bar_edge.position.y = hp_bar.position.y + hp_bar.size.y
