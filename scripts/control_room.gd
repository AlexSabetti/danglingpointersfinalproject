class_name ControlRoom
extends Node3D

var is_playing_turn_sound:bool = false

var signal_manager: SignalBus = SigBus

@onready var foumpAmbiSoundPLayer:AudioStreamPlayer3D = $FoumpAmbiLoop
@onready var deepCreakingAmbiSoundPLayer:AudioStreamPlayer3D = $DeepCreakingAmbiLoop
@onready var clusterAmbiSoundPLayer:AudioStreamPlayer3D = $ClusterAmbiLoop
@onready var turnSoundPlayer:AudioStreamPlayer3D = $TurnSoundEffect

func _ready()->void:
	signal_manager.connect("map_node_change", update_room_ambience)
	
	Global.controlRoomRef = self
	
	update_room_ambience(null)

# this is a bit messy lol, but it works for now
func _process(_delta: float) -> void:
	
	# controls turn sound
	if Global.gameControllerRef.twist_input != 0 && !is_playing_turn_sound:
		is_playing_turn_sound = true
		turnSoundPlayer.play()
		#print("play turn sound!")
	else: if Global.gameControllerRef.twist_input == 0 && is_playing_turn_sound:
		is_playing_turn_sound = false
		turnSoundPlayer.stop()
		#print("halting turn sound!")


func update_room_ambience(mapNode: MapNode):
	var curRoom:Room = null
	
	# get room child and find what ambience it should play
	if mapNode != null:
		for child in mapNode.get_children():
			if child is Room:
				curRoom = child as Room
	
	
	if curRoom != null && curRoom.room_ambience != "" :
		if curRoom.room_ambience.contains("FoumpWeak"):
			foumpAmbiSoundPLayer.volume_db = -10.0
			print("playing: FoumpWeak")
		else: if curRoom.room_ambience.contains("FoumpStrong"):
			foumpAmbiSoundPLayer.volume_db = 0.0
			print("playing: FoumpStrong")
		else:
			foumpAmbiSoundPLayer.volume_db = -80.0
		
		if curRoom.room_ambience.contains("MetalCreak"):
			deepCreakingAmbiSoundPLayer.volume_db = -20.0
			print("playing: MetalCreak")
		else:
			deepCreakingAmbiSoundPLayer.volume_db = -80.0
		
		if curRoom.room_ambience.contains("Cluster"):
			clusterAmbiSoundPLayer.volume_db = -0.0
			print("playing: Cluster")
		else:
			clusterAmbiSoundPLayer.volume_db = -80.0
		
	else:
		foumpAmbiSoundPLayer.volume_db = -80.0
		deepCreakingAmbiSoundPLayer.volume_db = -80.0
		clusterAmbiSoundPLayer.volume_db = -80.0
