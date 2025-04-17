class_name Room
extends DynamicEntity

# reference to which mapNode this room is occupying
@export var mapNode:MapNode

# coordinates of room in grid
var gridCoords: Vector2 = Vector2(0, 0)

var drone_in_room:bool = false

#@export var is_point_of_interest:bool = false

# name of ambience to play in this room. If empty, default ambience is played
@export var room_ambience:String = ""


# used to label which sides are possibly connectable to. this is just to prevent putting rockwall blockers in places that are already blocked off naturally
@export_category("potential openings")
@export var north_open:bool = false
@export var south_open:bool = false
@export var east_open:bool = false
@export var west_open:bool = false

# determines which entrences will be blocked off via a rock wall
@export_category("blocked off enterences")
@export var north_blocked: bool = false
var north_blocker:Node3D = null
@export var south_blocked: bool = false
var south_blocker:Node3D = null
@export var east_blocked: bool = false
var east_blocker:Node3D = null
@export var west_blocked: bool = false
var west_blocker:Node3D = null

@export_category("Triggers")
# array of objects that will be triggered upon entering the scene
@export var trigger_on_enter:Array[DynamicEntity]

#@export_category("Room Exit Colliders")
#@export var north_exit_collider:CameraChangeObject
#@export var east_exit_collider:CameraChangeObject
#@export var south_exit_collider:CameraChangeObject
#@export var west_exit_collider:CameraChangeObject

# instance of the rock wall to be used for blocking off opennings
const RoomDoorBlocker = preload("res://resources/Models/rock_wall_1_a_1.tscn")

var signal_manager: SignalBus = SigBus

@onready var RoomChangers: Node3D = $RoomChangers

func _ready() -> void:
	
	#signal_manager.connect("map_node_change", check_map_node)
	
	# set child roomchangers to trigger this room on interact
	if RoomChangers != null:
		for child in RoomChangers.get_children():
			if child is CameraChangeObject && (child as CameraChangeObject).isRoomChanger:
				var camChanger:CameraChangeObject = (child as CameraChangeObject)
				camChanger.trigger_on_interact.append(self)
	else:
		print("Can't find 'RoomChangers' as child of room")
	
	
	_update_blocked_paths()
	

# room is triggered when first entering it
func _on_trigger():
	# updates the drone to know where it is
	if mapNode != null:
		Global.gameControllerRef.drone.set_map_node(mapNode)
	else:
		print("No mapNode connected to this room.")
		
	_on_room_enter()

# triggers given objects on enter
func _on_room_enter() -> void:
	# signal the room change
	if mapNode != null:
		signal_manager.emit_signal("map_node_change", mapNode)
	
	for obj in trigger_on_enter:
		obj._on_trigger()

# triggers given objects on exit
#func _on_room_exit() -> void:
	#for obj in trigger_on_exit:
		#obj._on_trigger()
		

#func check_map_node(newMapNode: MapNode):
	## if drone is entering this room
	#if mapNode != null && newMapNode == mapNode:
		#drone_in_room = true
	## if drone is leaving this room
	#else: if drone_in_room:
		#pass

# Updates which paths should be blocked
# only check paths that are physically cappable of being blocked/unblocked, denoted by that paths open status
func _update_blocked_paths():
	# check NORTH enterence
	if north_open:
		if north_blocked && north_blocker == null:	# add blocker into scene
			#Make instance
			north_blocker = RoomDoorBlocker.instantiate()
			#Attach it to the tree
			self.add_child(north_blocker)
		else: if !north_blocked && north_blocker != null:	# remove blocker from scene
			north_blocker.queue_free()
	# check EAST enterence
	if east_open:
		if east_blocked && east_blocker == null:	# add blocker into scene
			#Make instance
			east_blocker = RoomDoorBlocker.instantiate()
			#Attach it to the tree
			self.add_child(east_blocker)
			# rotate into place
			east_blocker.rotation_degrees = Vector3(0.0,-90.0,0.0)
		else: if !east_blocked && east_blocker != null:	# remove blocker from scene
			east_blocker.queue_free()
	# check SOUTH enterence
	if south_open:
		if south_blocked && south_blocker == null:	# add blocker into scene
			#Make instance
			south_blocker = RoomDoorBlocker.instantiate()
			#Attach it to the tree
			self.add_child(south_blocker)
			# rotate into place
			south_blocker.rotation_degrees = Vector3(0.0,-180.0,0.0)
		else: if !south_blocked && south_blocker != null:	# remove blocker from scene
			south_blocker.queue_free()
	# check WEST enterence
	if west_open:
		if west_blocked && west_blocker == null:	# add blocker into scene
			#Make instance
			west_blocker = RoomDoorBlocker.instantiate()
			#Attach it to the tree
			self.add_child(west_blocker)
			# rotate into place
			west_blocker.rotation_degrees = Vector3(0.0,90.0,0.0)
		else: if !west_blocked && west_blocker != null:	# remove blocker from scene
			west_blocker.queue_free()
