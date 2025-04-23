class_name endgame
extends Node3D

@onready var manager: MapManager = get_parent().get_node("MapManager")

func _ready() -> void:
	trigger_ending()

func trigger_ending() -> void:
	# set the endgame state to true
	Global.gameControllerRef.is_endgame = true
	
	for i in range(manager.get_children_count()):
		var child = manager.get_child(i)
		await get_tree().create_timer(3).timeout
		if child is MapNode:
			# Maybe play a sound here
			# want everything to vanish
			# kick the player out of the screen when it deletes the room they are in 
			child.queue_free()
	
	

