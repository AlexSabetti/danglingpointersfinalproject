# this is the drone from which the players computer screen views the environment
class_name Drone
extends DynamicEntity

@export var active_cam_node:CameraNode
@export var active_map_node:MapNode

var signal_manager: SignalBus = SigBus

@onready var DroneCamera:Camera3D = $Camera3D

func _ready()->void:
	
	# hide editor icon
	$Sprite3D.visible = false
	
	# Moves the drone to the first active camera node, if it has been set
	if active_cam_node != null:
		self.global_position = active_cam_node.global_position
		self.global_rotation = active_cam_node.cam_default_rotation



# moves camera to it's active_cam_node
func update_cam_position():
	if active_cam_node != null:
		self.global_position = active_cam_node.global_position
		self.global_rotation = active_cam_node.cam_default_rotation
	
