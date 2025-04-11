# this is the drone from which the players computer screen views the environment
class_name Drone
extends DynamicEntity

@export var active_cam_node:CameraNode
@export var active_map_node:MapNode

@export var is_light_on:bool = false
@export var drone_light_energy:float = 0.5

var signal_manager: SignalBus = SigBus

@onready var DroneCamera:Camera3D = $Camera3D
@onready var DroneLight1 := $Camera3D/SpotLight3D1
@onready var DroneLight2 := $Camera3D/SpotLight3D2

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
		#self.global_rotation = active_cam_node.cam_default_rotation
	

# toggles the drones spotlights on or off
func toggle_light():
	if is_light_on:
		DroneLight1.light_energy = 0.0
		DroneLight2.light_energy = 0.0
		is_light_on = false
	else:
		DroneLight1.light_energy = drone_light_energy
		DroneLight2.light_energy = drone_light_energy
		is_light_on = true
