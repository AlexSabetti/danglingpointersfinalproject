class_name MapManager
extends Node3D

@export_category("Map Properties")
@export var grid_count: int = 16 # MUST BE A ROOTABLE VALUE
@export var cell_size: int = 20 # Change this if we change the room sizes
@export var active_cell_count: int = 0 # How many cells we've already placed rooms in

@export var node_scene: PackedScene # MUST BE FILLED IN
@export var starting_area: PackedScene = null # MUST BE FILLED IN
@export var original_node_loc: Vector3 = Vector3(0, 0, 0)
@export var num_pois: int = 4

# Starting area, all 4 directions open
var room1_a1 : PackedScene = preload("res://scenes/Levels/Rooms/room1_a1.tscn")

# line, two openings, one pointing negative z and one pointing positive z
var room2_a1 : PackedScene = preload("res://scenes/Levels/Rooms/room2_a1.tscn")

# T-shaped, three openings, POI, one negative x, one positive z, one negative z
var room3_a1 : PackedScene = preload("res://scenes/Levels/Rooms/room3_a1.tscn") 

# Corner, POI, two openings, one pointing negative x, one positive z
var room4_a1 : PackedScene = preload("res://scenes/Levels/Rooms/room4_a1.tscn") 

# Corner, two openings, one pointing positive x, one negative z
var room5_a1 : PackedScene = preload("res://scenes/Levels/Rooms/room5_a1.tscn")

# T-shape, three openings, one pointing negative x, one pointing positive z, and the last one pointing negative z
var room6_a1 : PackedScene = preload("res://scenes/Levels/Rooms/room6_a1.tscn")

# Dead end, one opening, pointing positive z
var room7_a1 : PackedScene = preload("res://scenes/Levels/Rooms/room7_a1.tscn") 

var starting_node: MapNode = null
var starting_node_place : int = -1

var key_areas: Array = []
var points_of_interest: Array = []
var paths: Array = []
var crosses: Array = []
var available_nodes: Array = []
var available_nodes_count: int = 0

var key_area_type_a_created: bool = false
var key_area_type_b_created: bool = false

var root_count: int = -1
var head: MapNode = null

func _ready():
	root_count = sqrt(grid_count)
	Create_Map()
	start_map()
	expand_map()
	

func Create_Map():
	var node_cur_pos: Vector3 = original_node_loc
	for i in range(0, root_count):
		for j in range(0, root_count):
			node_cur_pos = Vector3(i * cell_size, 0, j * cell_size) # Tweak this
			var walker = node_scene.instantiate()
			add_child(walker)
			walker.global_position = node_cur_pos
			walker.place_pos = i * root_count + j
			var placement_above = i * root_count + j - root_count
			if placement_above >= 0:
				get_child(placement_above).south = walker
				walker.north = get_child(placement_above)
			
			if j > 0:
				get_child(i * root_count + j - 1).east = walker
				walker.west = get_child(i * root_count + j - 1)
			available_nodes.append(walker)
			available_nodes_count += 1
	head = get_child(0)
		
	
func start_map():
	var rng = RandomNumberGenerator.new()
	var starting_tile = rng.randi_range(0, grid_count)
	starting_node = get_child(starting_tile)
	# remove from available nodes
	available_nodes.remove_at(starting_tile)
	available_nodes_count -= 1
	starting_node.active = true
	starting_node_place = starting_tile

	# We will instantiate the starting scene here, along with its exits

	var starting_scene = starting_area.instantiate()
	starting_node.add_child(starting_scene)
	starting_scene.global_position = starting_node.global_position

	# Don't know the specifics for how we're going to put up blockers yet, but we'll start with the bools

	if(starting_node.north_node == null):
		starting_node.north_open = false
	if(starting_node.south_node == null):
		starting_node.south_open = false
	if(starting_node.east_node == null):
		starting_node.east_open = false
	if(starting_node.west_node == null): 
		starting_node.west_open = false

func expand_map():
	var rng = RandomNumberGenerator.new()
	# There are many ways to go about doing this, but for now what I'll do is select two-three random nodes
	# I'll label the selected ones as "key areas" and then I'll try to expand from the starting node to connect there
	# Then I'll select a few more random nodes and label them "points of interest" and try to connect them to a key area, an already established path, or the starting area, whichever is closer
	var first_key_area = -1
	var second_key_area = -1

	
	first_key_area = rng.randi_range(0, available_nodes_count)
	available_nodes.remove_at(first_key_area)
	available_nodes_count -= 1
	second_key_area = rng.randi_range(0, grid_count)
	available_nodes.remove_at(second_key_area)
	available_nodes_count -= 1

	key_areas.append(get_child(first_key_area))
	key_areas.append(get_child(second_key_area))

	connect_to(first_key_area, starting_node_place)

	# Second key area
	var second_key_area_node = get_child(second_key_area)
	var connection = find_closest_tile(second_key_area)
	connect_to(second_key_area, connection.place_pos)

	# Points of interest
	for i in range(0, num_pois):
		var coin_flip = rng.randi_range(0, 2)
		if coin_flip:
			# Take over a path
			var path_index = rng.randi_range(0, paths.size())
			var path = paths[path_index]
			points_of_interest.append(path)
			paths.remove_at(path_index)
		else:
			# take over a random area
			var area_index = rng.randi_range(0, available_nodes_count)
			var area = available_nodes[area_index]
			available_nodes.remove_at(area_index)
			available_nodes_count -= 1
			points_of_interest.append(area)
			var closest_tile = find_closest_tile(area.place_pos)
			connect_to(area.place_pos, closest_tile)
	location_creation()


func location_creation():
	# Go through the paths first
	for i in range(0, paths.size()):
		var path = paths[i]
		assign_scene(path, 0)
		path.create_scene()

	for i in range(0, crosses.size()):
		var cross = get_child(crosses[i])
		assign_scene(cross, 1)
		cross.create_scene()

	for i in range(0, points_of_interest.size()):
		var poi = points_of_interest[i]
		assign_scene(poi, 2)
		poi.create_scene()
		
	for i in range(0, key_areas.size()):
		var key_area = key_areas[i]
		assign_scene(key_area, 3)
		key_area.create_scene()
	
func assign_scene(node: MapNode, stage: int):
	var openings = find_number_of_openings(node)
	if stage == 4:
		# key area
		if key_area_type_a_created:
			node.scene_path = room4_a1
			key_area_type_b_created = true
			if node.south_open:
				if node.west_open:
					node.rotate_by = -90
			elif node.north_open:
				if node.west_open:
					node.rotate_by = 180
				else:
					node.rotate_by = 90
			elif node.west_open:
				node.rotate_by = -90
		else:
			node.scene_path = room3_a1
			key_area_type_a_created = true
			if openings == 1 and node.north_open:
				node.rotate_by = 180
			elif openings == 2:
				if node.north_open and node.south_open:
					node.rotate_by = 90
			elif openings == 3:
				if !node.south_open:
					node.rotate_by = 180
				elif !node.east_open:
					node.rotate_by = -90
				elif !node.west_open:
					node.rotate_by = 90
		return
	
	if openings == 4:
		# Have to use this room here, should rarely if ever happen
		node.scene_path = room1_a1
	elif openings == 3:
		if stage == 0:
			node.scene_path = room6_a1
		else:
			node.scene_path = room3_a1
	elif openings == 2:
		if stage == 0:
			# Line section, only called when paths are being created
			node.scene_path = room2_a1
		elif stage == 1:
			# corner section, only called when crosses are being created
			node.scene_path = room5_a1
		else:
			# corner section, only called when Key Areas are being created
			node.scene_path = room4_a1
	elif openings == 1:
		node.scene_path = room7_a1
		if node.north_open:
			node.rotate_by = 180
		elif node.east_open:
			node.rotate_by = 90
		elif node.west_open:
			node.rotate_by = -90
	else:
		node.scene_path = room5_a1 

func find_closest_tile(position_from: int) -> int:
	var node = get_child(position_from)
	var connection_dist = root_count * root_count + 1
	for i in range(0, key_areas.size()):
		if abs(position_from - key_areas[i].place_pos) < connection_dist:
			connection_dist = abs(position_from - key_areas[i].place_pos)
	for i in range(0, points_of_interest.size()):
		if abs(position_from - points_of_interest[i].place_pos) < connection_dist:
			connection_dist = abs(position_from - points_of_interest[i].place_pos)
	for i in range(0, paths.size()):
		if abs(position_from - paths[i].place_pos) < connection_dist:
			connection_dist = abs(position_from - paths[i].place_pos)
	return connection_dist

func find_number_of_openings(node: MapNode) -> int:
	var openings = 0
	if node.north_open:
		openings += 1
	if node.south_open:
		openings += 1
	if node.east_open:
		openings += 1
	if node.west_open:
		openings += 1
	return openings

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
			crosses.append(cross_pos)
		for i in range(1, rows_away):
			var potential_path: MapNode = get_child(cross_pos - (i * root_count))
			potential_path.north_open = true
			potential_path.south_open = true  
			potential_path.active = true
			paths.append(potential_path)
		starting_node.south_open = true
		cross_pos.active = true
			
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
			crosses.append(cross_pos)
		for i in range(1, rows_away):
			var potential_path: MapNode = get_child(cross_pos + (i * root_count))
			potential_path.north_open = true
			potential_path.south_open = true
			potential_path.active = true
			paths.append(potential_path)
		get_child(position_to).north_open = true
		cross_pos.active = true
