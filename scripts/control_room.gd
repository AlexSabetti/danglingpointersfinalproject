class_name ControlRoom
extends Node3D

var is_playing_sound:bool = false

@onready var turnSoundPlayer:AudioStreamPlayer3D = $TurnSoundEffect

func _ready()->void:
	pass

# this is a bit messy lol, but it works for now
func _process(_delta: float) -> void:
	if Global.gameControllerRef.twist_input != 0 && !is_playing_sound:
		is_playing_sound = true
		turnSoundPlayer.play()
		#print("play turn sound!")
	else: if Global.gameControllerRef.twist_input == 0 && is_playing_sound:
		is_playing_sound = false
		turnSoundPlayer.stop()
		#print("halting turn sound!")
