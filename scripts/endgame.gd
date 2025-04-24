class_name endgame
extends Node3D

@onready var manager: MapManager = get_parent().get_node("MapManager")

var signal_manager: SignalBus = SigBus

func _ready() -> void:
	signal_manager.connect("endgame", trigger_ending)

func trigger_ending() -> void:
	# set the endgame state to true
	Global.gameControllerRef.is_endgame = true
	var str_array: Array[String] = ["aen utbioyaeroituaynberiutyabneruitymoihauretbn", "tphnuirtyhoeunrowiendfoiuandytgbiaunguihafdog", "nyatoeirtybaeorutyboaerynguhhaeirhutoaehrtoaerithaer", "nauygonuodyangbChngoifhAaodfgdNdgdfgYadpfhgpadhfgpOajhfgUdfgnlnjlkjnSjlsjglEd;fkgdfg;Efdgjhdlfgh?", "- Connection Lost -"]
	signal_manager.emit_signal("dialog_change", str_array)
	await get_tree().create_timer(10).timeout
	signal_manager.emit_signal("change_name", " ")
	str_array = ["Do you ever wonder", "If people you used to know", "still remember you?"]
	signal_manager.emit_signal("dialog_change", str_array)
	await get_tree().create_timer(3).timeout
	signal_manager.emit_signal("change_name", "A D M I N I S T R A T I O N")
	str_array = ["Crash imminent - Are you sure you know what you're doing?"]
	signal_manager.emit_signal("dialog_change", str_array)
	await get_tree().create_timer(3).timeout
	str_array = ["... A game by-"]
	signal_manager.emit_signal("dialog_change", str_array)
	for i in range(manager.get_children_count()):
		var child = manager.get_child(i)
		await get_tree().create_timer(3).timeout
		if child is MapNode:
			# Maybe play a sound here
			# want everything to vanish
			# kick the player out of the screen when it deletes the room they are in 
			child.queue_free()
	
	

