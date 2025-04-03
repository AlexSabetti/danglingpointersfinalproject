class_name MapNode
extends Node

@export var scene_path: PackedScene
# Pointers to all surrounding nodes
@export var north: MapNode
@export var south: MapNode
@export var east: MapNode
@export var west: MapNode

# booleans
@export var active: bool = false
@export var north_open: bool = true
@export var south_open: bool = true
@export var east_open: bool = true
@export var west_open: bool = true

