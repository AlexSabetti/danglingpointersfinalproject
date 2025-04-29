class_name endgame
extends Node3D

@onready var manager: MapManager = get_parent().get_node("Manager")

var signal_manager: SignalBus = SigBus
signal finished()

func _ready() -> void:
	signal_manager.connect("end_game", trigger_ending)
	

func trigger_ending() -> void:
	await get_tree().create_timer(4).timeout
	# set the endgame state to true
	# Global.gameControllerRef.is_endgame = true
	var str_array: Array[String] = ["aen utbioyaeroituaynberiutyabneruitymoihauretbn", "tphnuirtyhoeunrowiendfoiuandytgbiaunguihafdog", "nyatoeirtybaeorutyboaerynguhhaeirhutoaehrtoaerithaer", "nauygonuodyangbChngoifhAaodfgdNdgdfgYadpfhgpadhfgpOajhfgUdfgnlnjlkjnSjlsjglEd;fkgdfg;Efdgjhdlfgh?", "- Connection Lost -"]
	signal_manager.emit_signal("dialog_event", str_array)
	await get_tree().create_timer(10).timeout
	signal_manager.emit_signal("change_name", " ")
	str_array = ["Do you ever wonder", "If people you used to know", "still remember you?"]
	signal_manager.emit_signal("dialog_event", str_array)
	await get_tree().create_timer(9).timeout
	signal_manager.emit_signal("change_name", "A D M I N I S T R A T I O N")
	str_array = ["Sim Crash imminent - Are you sure you knew what you were doing?"]
	signal_manager.emit_signal("dialog_event", str_array)
	await get_tree().create_timer(10).timeout
	str_array = ["... A game by Colin and Alex"]
	signal_manager.emit_signal("dialog_event", str_array)
	for i in range(manager.get_child_count()):
		var child = manager.get_child(i)
		await get_tree().create_timer(1).timeout
		# WILL CRASH HERE
		# want everything to vanish
		# THIS IS INTENTIONAL
		child.queue_free()
		if(i == manager.get_child_count() - 1):
			finished.emit()
	await finished
	get_tree().quit()
