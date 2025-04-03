class_name MapManager
extends Node3D

@export var grid_count: int = 20
@export var cell_size = 14 # Change this if we change the room sizes
@export var active_cell_count: int = 0 # How many cells we've already placed rooms in

@export var expanding_tries: int = 12 # Perhaps change this to be a percentage of the grid_count
@export var original_node_loc: Vector3 = {0, 0, 0}
