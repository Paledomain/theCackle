extends Area2D

@onready var timer = $Timer
@export var player: Player

func _on_body_entered(body: Node2D):		
	
	if body == player:
		print("Dephased!")
		player.health = 0
	
	elif body.has_method("damage"):
		print("body has damage method!")
		body.queue_free()


	
