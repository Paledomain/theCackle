extends Node2D

@export var checkpoint_list: Array[Node]
@export var player: Player

const Checkpoint = preload("res://Scripts/checkpoint.gd")

# Finds and returns the last active checkpoint in the array
func get_last_active_checkpoint() -> Checkpoint:
	for i in range(checkpoint_list.size() - 1, -1, -1): # Iterate backwards
		var checkp = checkpoint_list[i] as Checkpoint
		if checkp.is_active:
			return checkp
	return null # Return null if no active checkpoint is found


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func revive():
		var checkp = get_last_active_checkpoint()
		if checkp != null:
			if checkp.infiniteRespawn:
				player.is_second_wind = false
			player.respawn()
			player.position = checkp.getRespawnPosition()
			checkp.heal_particles.emitting = true
		else:
			print("No checkpoints! DEATH!")
			get_tree().reload_current_scene()
