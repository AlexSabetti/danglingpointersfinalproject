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
	var str_array: Array[String] = ["7504565775790212-124668979403012344", "23074017208470560012039750293743123333533", "12398610461C800862A08086502N8847Y87086243O57935989U027340923S84234E4234567E45345?", "- Connection Lost -"]
	signal_manager.emit_signal("dialog_event", str_array)
	await get_tree().create_timer(10).timeout
	signal_manager.emit_signal("change_name", " ")
	str_array = ["Do you ever wonder", "If people you used to know still remember you?"]
	signal_manager.emit_signal("dialog_event", str_array)
	await get_tree().create_timer(7).timeout
	signal_manager.emit_signal("change_name", "A D M I N I S T R A T I O N")
	str_array = ["Sim Crash imminent - Are you sure you knew what you were doing?"]
	signal_manager.emit_signal("dialog_event", str_array)
	await get_tree().create_timer(5).timeout
	signal_manager.emit_signal("change_name, " ")
	str_array = ["... A game by Colin and Alex"]
	signal_manager.emit_signal("dialog_event", str_array)
	str_array = ["DEAD STICK"]
	for i in range(manager.get_child_count()):
		var child = manager.get_child(i)
		signal_manager.emit_signal("dialog_event", str_array)
		await get_tree().create_timer(1).timeout
		# WILL CRASH HERE
		# want everything to vanish
		# THIS IS INTENTIONAL
		child.queue_free()
		if(i == manager.get_child_count() - 1):
		# Once in a blue moon it will get here, and if it does...
			signal_manager.emit_signal("dialog_event", ["You're still here?"])
			finished.emit()
	await finished
	# Close the game
	get_tree().quit()
