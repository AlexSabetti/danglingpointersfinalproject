class_name UI_MapDisplay
extends CanvasLayer


@onready var CompassPointer := $Compass/CompassPointer

func _process(delta: float) -> void:
	# update the compass rotation 
	if Global.gameControllerRef.drone:
		CompassPointer.rotation = -Global.gameControllerRef.drone.DroneCamera.global_rotation.y
