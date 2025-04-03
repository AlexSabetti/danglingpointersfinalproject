@tool
# Node used to denote a location the camera can be positioned.
class_name CameraNode
extends DynamicEntity

@export_category("camera node properties")
var camera:Camera3D
@export var  is_active_cam: bool = false
var cam_default_rotation: Vector3 = Vector3.ZERO  # default rotation of the camera
@export var can_player_rotate: bool = false       # whether or not the player is able to rotate the camera
@export var min_h_rotation: float = -45           # min degrees of rotation from the starting point that the camera can be rotated horizontally by
@export var max_h_rotation: float = 45            # max degrees of rotation from the starting point that the camera can be rotated horizontally by
@export var connected_nodes: Array[DynamicEntity] = []: # array of other camera positon nodes that can be reached from this one
	set(nodes):
		connected_nodes = nodes

func _ready():
	
	# Looks for Camera3D child
	for child in get_children():
		if child is Camera3D:
			camera = child as Camera3D
	
	# if not in editor
	if !Engine.is_editor_hint():
		# hides the camera object in game
		$FilmCamera1_a1.visible = false
		
		# if this is the active cam by default
		if is_active_cam:
			camera.set_current(true)
			Global.gameControllerRef.cur_cam = self
	
	
	update_configuration_warnings()

func _get_configuration_warnings():
	# Looks for Camera3D child
	for child in get_children():
		if child is Camera3D:
			camera = child as Camera3D
	
	if camera == null:
		return ["Expected a child of type Camera3D."]
	
	return 

# When triggered by an external object, sets this camera position node as the active node
func _trigger():
	set_current_node()

# Sets this camera node as the viewport
func set_current_node():
	if camera != null:
		Global.gameControllerRef.cur_cam.is_active_cam = false
		Global.gameControllerRef.cur_cam = self
		is_active_cam = true
		camera.rotation = cam_default_rotation # returns camera to it's starting rotation
		camera.set_current(true)
	else:
		print("no child Camera3D found")

# Switch from this current camera positon to the node at the given index in the connected_nodes array
func switch_to_node(idx:int):
	if connected_nodes[idx] != null and connected_nodes[idx] is CameraNode:
		is_active_cam = false
		(connected_nodes[idx] as CameraNode).set_current_node()
	else:
		print("can not switch to invalid camPosNode")
	pass
