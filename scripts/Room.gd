class_name Room
extends DynamicEntity

@export var mapNode:MapNode

#@export var is_point_of_interest:bool = false

@export var north_open: bool = false
@export var south_open: bool = false
@export var east_open: bool = false
@export var west_open: bool = false

@export_category("Triggers")
# array of objects that will be triggered upon entering the scene
@export var trigger_on_enter:Array[DynamicEntity]

# array of objects that will be triggered upon entering the scene
@export var trigger_on_exit:Array[DynamicEntity]

#@export_category("Camera Nodes")
#@export var north_cam_node:CameraNode
#@export var east_cam_node:CameraNode
#@export var south_cam_node:CameraNode
#@export var west_cam_node:CameraNode

#@export_category("Room Exit Colliders")
#@export var north_exit_collider:CameraChangeObject
#@export var east_exit_collider:CameraChangeObject
#@export var south_exit_collider:CameraChangeObject
#@export var west_exit_collider:CameraChangeObject

func _ready() -> void:
	pass

func _on_trigger():
	# updates the drone to know where it is
	if mapNode != null:
		Global.gameControllerRef.drone.set_map_node(mapNode)

# triggers given objects on enter
func _on_room_enter() -> void:
	for obj in trigger_on_enter:
		obj._on_trigger()

# triggers given objects on exit
func _on_room_exit() -> void:
	for obj in trigger_on_exit:
		obj._on_trigger()
