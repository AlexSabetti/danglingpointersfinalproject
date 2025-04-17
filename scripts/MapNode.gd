class_name MapNode
extends Node3D

@export var scene_path: PackedScene
# Pointers to all surrounding nodes
@export var north: MapNode
@export var south: MapNode
@export var east: MapNode
@export var west: MapNode

# booleans
@export var active: bool = false
@export var north_open: bool = false
@export var south_open: bool = false
@export var east_open: bool = false
@export var west_open: bool = false

var rotate_by = 0.0

func create_scene():
	# Create the scene and add it to the node
	var scene_instance = scene_path.instantiate()
	add_child(scene_instance)
	
	# Set the position of the scene instance
	scene_instance.position = global_transform.origin
	scene_instance.rotation_degrees = Vector3(0, rotate_by, 0)
