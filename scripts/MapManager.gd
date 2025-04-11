class_name MapManager
extends Node3D

@export_category("Map Properties")
@export var grid_count: int = 16 # MUST BE A ROOTABLE VALUE
@export var cell_size = 16 # Change this if we change the room sizes
@export var active_cell_count: int = 0 # How many cells we've already placed rooms in
@export var required_areas: int = 4 # Story-Specific mission areas, the expansion function must place this many

@export node_scene: MapNode # MUST BE FILLED IN
@export starting_area: PackedScene # MUST BE FILLED IN

@export var expanding_tries: int = 12 # Perhaps change this to be a percentage of the grid_count
@export var original_node_loc: Vector3 = {0, 0, 0}

var starting_node: MapNode = NULL
var starting_node_place : int = -1

var key_areas: Array = []
var points_of_interest: Array = []
var paths: Array = []

var root_count: int = -1
var head: MapNode = NULL
func _ready():
  root_count = sqrt(grid_count)
  Create_Map()

func Create_Map():
  var node_cur_pos: Vector3 = original_node_loc

  
  for i in range(0, root_count):
	for j in range(0, root_count):
	  node_cur_pos = (i * cell_size, 0, j * cell_size) # Tweak this
	  var scene = load(node_scene)
	  var walker = scene.instantiate()
	  add_child(walker)
	  walker.global_position = node_cur_pos
	  walker.place_pos = i * root + j
	  var placement_above = i * root + j - root
	  if placement_above >= 0:
		get_child(placement_above).south_node = walker
		walker.north_node = get_child(placement_above)
	  walker.south_node = NULL
	  if j > 0:
		get_child(i * root + j - 1).east_node = walker
		walker.west_node = get_child(i * root + j - 1)
  head = get_child(0)
		
	
func start_map():
  var rng = RandomNumberGenerator.new()
  var starting_tile = rng.rand_range(0, grid_count)
  starting_node = get_child(starting_tile)
  starting_node.active = true
  starting_node_place = starting_tile
  
  # We will instantiate the starting scene here, along with its exits
  
  var starting_scene = starting_area.instantiate()
  starting_node.add_child(starting_scene)
  starting_scene.global_position = starting_node.global_position

  # Don't know the specifics for how we're going to put up blockers yet, but we'll start with the bools

  if(starting_node.north_node == NULL):
	starting_node.north_open = false
  if(starting_node.south_node == NULL):
	starting_node.south_open = false
  if(starting_node.east_node == NULL):
	starting_node.east_open = false
  if(starting_node.west_node == NULL): 
	starting_node.west_open = false

func expand_map():
  var rng = RandomNumberGenerator.new()
  # There are many ways to go about doing this, but for now what I'll do is select two-three random nodes
  # I'll label the selected ones as "key areas" and then I'll try to expand from the starting node to connect there
  # Then I'll select a few more random nodes and label them "points of interest" and try to connect them to a key area, an already established path, or the starting area, whichever is closer
  var first_key_area = -1
  var second_key_area = -1

  while first_key_area == second_key_area || first_key_area == starting_node_place || second_key_area == starting_node_place:
	first_key_area = rng.rand_range(0, grid_count)
	second_key_area = rng.rand_range(0, grid_count)
  # On smaller maps, this might loop for a long time, so this is the first and last time we're doing this

  key_areas.append(get_child(first_key_area))
  key_areas.append(get_child(second_key_area))

  connect_to(first_key_area, starting_node_place)
  
  # Second key area
  var second_key_area_node = get_child(second_key_area)
  var connection_dist = second_key_area - first_key_area
  var connection = get_child(first_key_area)
  if(abs(second_key_area - starting_node_place) < abs(connection_dist)): 
	connection_dist = second_key_area - starting_node_place
	connection = starting_node
  for i in range(0, paths.size):
	if(abs(second_key_area - paths[i].place_pos) < abs(connection_dist)):
		connection_dist = second_key_area - paths[i].place_pos
		connection = paths[i]

  connect_to(second_key_area, connection.place_pos)
  



func connect_to( position_from: int, position_to: int):
  var dist = position_to - position_from
  var cross_pos = -1
  if dist < 0:
    # Below or to the right
    var rows_away: int = abs(dist) / root_count
    var cols_away: int = abs(dist) % root_count
    cross_pos = position_from - cols_away
    if cross_pos !=position_from:
      get_child(cross_pos).east_open = true
      get_child(position_from).west_open = true
      for i in range(1, cols_away):
	var potential_path: MapNode = get_child(cross_pos + i)
        potential_path.west_open = true
	potential_path.east_open = true
	potential_path.active = true
	paths.append(potential_path)
      if(cross_pos != position_to):
        get_child(cross_pos).north_open = true
        for i in range(1, rows_away):
		var potential_path: MapNode = get_child(cross_pos - (i * root_count))
		potential_path.north_open = true
		potential_path.south_open = true
		potential_path.active = true
		paths.append(potential_path)
       starting_node.south_open = true
       cross_pos.active = true
       paths.append(cross_pos)
  else:
    # Above or to the left
    var rows_away = abs(dist) / root_count
    var cols_away = abs(dist) % root_count
    cross_pos = position_from + cols_away
    if cross_pos != position_from:
	get_child(cross_pos).west_open = true
	get_child(position_from).east_open = true
	for i in range(1, cols_away):
		var potential_path: MapNode = get_child(cross_pos - i)
		potential_path.west_open = true
		potential_path.east_open = true
		potential_path.active = true
		paths.append(potential_path)
    if(cross_pos != position_to):
    	get_child(cross_pos).south_open = true
	for i in range(1, rows_away):
		var potential_path: MapNode = get_child(cross_pos + (i * root_count))
		potential_path.north_open = true
		potential_path.south_open = true
		potential_path.active = true
		paths.append(potential_path)
        position_to.north_open = true
        cross_pos.active = true

