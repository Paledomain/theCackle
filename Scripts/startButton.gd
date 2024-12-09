extends Button
@onready var click = $click
@onready var timer = $Timer
@onready var animated_sprite_2d = $"../AnimatedSprite2D"
@onready var control = $".."

@export var modulval: Color
@export var standart: Color
var tween: Tween
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_pressed():
	click.play()
	timer.start()
	control.modulate =modulval
	tween = create_tween()
	tween.tween_property(control, "modulate", Color.BLACK, 0.2)
	tween.tween_property(control, "modulate", standart, 0.1)
	


func _on_timer_timeout():
	animated_sprite_2d.modulate =standart
	get_tree().change_scene_to_file("res://Scenes/game.tscn")
	
