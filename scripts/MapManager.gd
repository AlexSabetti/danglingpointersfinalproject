class_name MapManager
extends Node3D

@export var grid_count: int = 16 # MUST BE A ROOTABLE VALUE
@export var cell_size = 16 # Change this if we change the room sizes
@export var active_cell_count: int = 0 # How many cells we've already placed rooms in

@export node_scene: MapNode # MUST BE FILLED IN
@export starting_area: PackedScene # MUST BE FILLED IN

@export var expanding_tries: int = 12 # Perhaps change this to be a percentage of the grid_count
@export var original_node_loc: Vector3 = {0, 0, 0}

var head: MapNode = NULL
func _ready():
  Create_Map()

func Create_Map():
  var node_cur_pos: Vector3 = original_node_loc

  var root_count = sqrt(grid_count)
  for i in range(0, root_count):
	for j in range(0, root_count):
	  node_cur_pos = {i * cell_size, 0, j * cell_size) # Tweak this
	  var scene = load(node_scene)
	  var walker = scene.instantiate()
	  add_child(walker)
	  walker.global_position = node_cur_pos
	  var placement_above = i * root + j - root
	  if placement_above >= 0:
		get_child(placement_above).south_node = walker
		walker.north_node = get_child(placement_above)
	  else :
		walker.south_node = NULL
	  if j > 0:
		get(child(i * root + j - 1).east_node = walker
		walker = get_child(i * root + j - 1)
  head = get_child(0)
		
	
  head.north_node = NULL
  
  head.west_node = NULL
  head.
  
