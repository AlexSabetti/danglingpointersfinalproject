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
      var placement_above = i * root + j - root
      if placement_above >= 0:
        get_child(placement_above).south_node = walker
        walker.north_node = get_child(placement_above)
      else :
        walker.south_node = NULL
      if j > 0:
        get_child(i * root + j - 1).east_node = walker
        walker = get_child(i * root + j - 1)
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

  var num = starting_node_place - first_key_area
  var cross_pos = -1
  if num < 0:
    # Below or to the right
    var rows_away = abs(num) / root_count
    var cols_away = abs(num) % root_count
    cross_pos = first_key_area - cols_away
    if cross_pos !=first_key_area:
      get_child(cross_pos).west_open = true
      for i in range(0, cols_away):
        get_child(cross_pos + i)
    else:
      get_child(cross_pos).south_open = true


    # This will be the cross section
  else:
    # Above or to the left
    var rows_away = abs(num) / root_count
    var cols_away = abs(num) % root_count
    cross_pos = first_key_area + cols_away
