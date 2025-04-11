class_name Room
extends Node3D

@export var mapNode:MapNode

#@export var is_point_of_interest:bool = false

@export var north_open: bool = false
@export var south_open: bool = false
@export var east_open: bool = false
@export var west_open: bool = false

@export_category("Camera Nodes")
#@export var north_cam_node:CameraNode
#@export var east_cam_node:CameraNode
#@export var south_cam_node:CameraNode
#@export var west_cam_node:CameraNode

@export_category("Room Exit Colliders")
#@export var north_exit_collider:CameraChangeObject
#@export var east_exit_collider:CameraChangeObject
#@export var south_exit_collider:CameraChangeObject
#@export var west_exit_collider:CameraChangeObject

func _ready() -> void:
	pass
	

func check_connections() -> void:
	
	pass
