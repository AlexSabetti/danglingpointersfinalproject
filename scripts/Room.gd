class_name Room
extends DynamicEntity

# reference to which mapNode this room is occupying
@export var mapNode:MapNode

# coordinates of room in grid
var gridCoords: Vector2 = Vector2(0, 0)

#@export var is_point_of_interest:bool = false

# user to label which sides are possibly connectable to
@export var north_open: bool = false
@export var east_open: bool = false
@export var south_open: bool = false
@export var west_open: bool = false

@export_category("blocked off enterences")
@export var north_blocked: bool = false
@export var east_blocked: bool = false
@export var south_blocked: bool = false
@export var west_blocked: bool = false

@export_category("Triggers")
# array of objects that will be triggered upon entering the scene
@export var trigger_on_enter:Array[DynamicEntity]

#@export_category("Room Exit Colliders")
#@export var north_exit_collider:CameraChangeObject
#@export var east_exit_collider:CameraChangeObject
#@export var south_exit_collider:CameraChangeObject
#@export var west_exit_collider:CameraChangeObject

const RoomDoorBlocker = preload("res://resources/Models/rock_wall_1_a_1.tscn")

func _ready() -> void:
	
	
	if north_blocked:
		#Make instance
		var WallInstance:Node3D = RoomDoorBlocker.instantiate()
		#Attach it to the tree
		self.add_child(WallInstance)
	if east_blocked:
		#Make instance
		var WallInstance:Node3D = RoomDoorBlocker.instantiate()
		#Attach it to the tree
		self.add_child(WallInstance)
		# rotate into place
		WallInstance.rotation_degrees = Vector3(0.0,-90.0,0.0)
	if south_blocked:
		#Make instance
		var WallInstance:Node3D = RoomDoorBlocker.instantiate()
		#Attach it to the tree
		self.add_child(WallInstance)
		# rotate into place
		WallInstance.rotation_degrees = Vector3(0.0,-180.0,0.0)
	if west_blocked:
		#Make instance
		var WallInstance:Node3D = RoomDoorBlocker.instantiate()
		#Attach it to the tree
		self.add_child(WallInstance)
		# rotate into place
		WallInstance.rotation_degrees = Vector3(0.0,90.0,0.0)
		

# room is triggered when first entering it
func _on_trigger():
	# updates the drone to know where it is
	if mapNode != null:
		Global.gameControllerRef.drone.set_map_node(mapNode)

# triggers given objects on enter
func _on_room_enter() -> void:
	for obj in trigger_on_enter:
		obj._on_trigger()

# triggers given objects on exit
#func _on_room_exit() -> void:
	#for obj in trigger_on_exit:
		#obj._on_trigger()
