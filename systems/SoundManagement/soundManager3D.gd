#class_name SoundManager3D
extends Node3D


var SoundQueuesByName := {}
var SoundPoolsByName := {}


func _ready() -> void:
	SoundQueuesByName = {
		"SQ_Boink" : $SQ_Boink,
		"SQ_Tick" : $SQ_Tick,
		"SQ_CFonk" : $SQ_CFonk,
	}
	SoundPoolsByName = {
		"SP_Voice" : $SP_Voice
	}
	

func PlaySoundPool3D(soundPoolName:String, positon:Vector3)->void:
	if SoundPoolsByName[soundPoolName]:
		SoundPoolsByName[soundPoolName].PlayRandomSoundAt(positon)
	else:
		print("Invalid soundPool name: " + soundPoolName)

func PlaySoundQueue3D(soundQueueName:String, positon:Vector3)->void:
	if SoundQueuesByName[soundQueueName]:
		SoundQueuesByName[soundQueueName].PlaySoundAt(positon)
	else:
		print("Invalid soundQueue name: " + soundQueueName)
