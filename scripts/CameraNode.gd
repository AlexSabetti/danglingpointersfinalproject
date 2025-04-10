@tool
# Node used to denote a location the camera can be positioned.
class_name CameraNode
extends DynamicEntity

@export_category("camera node properties")
var camera:Camera3D
var cam_default_rotation: Vector3 = Vector3.ZERO  # default rotation of the camera
@export var can_player_rotate: bool = false       # whether or not the player is able to rotate the camera
@export var min_h_rotation: float = -45           # min degrees of rotation from the starting point that the camera can be rotated horizontally by
@export var max_h_rotation: float = 45            # max degrees of rotation from the starting point that the camera can be rotated horizontally by
#@export var connected_nodes: Array[CameraNode] = []: # array of other camera positon nodes that can be reached from this one
	#set(nodes):
		#connected_nodes = nodes

var signal_manager: SignalBus = SigBus

@onready var Delay:Timer = $Delay

func _ready():
	
	## Looks for Camera3D child
	#for child in get_children():
		#if child is Camera3D:
			#camera = child as Camera3D
	
	# if not in editor
	if !Engine.is_editor_hint():
		# hides the camera object in game
		$FilmCamera1_a1.visible = false
		
		
		cam_default_rotation = rotation

#func _get_configuration_warnings():
	## Looks for Camera3D child
	#for child in get_children():
		#if child is Camera3D:
			#camera = child as Camera3D
	#
	#if camera == null:
		#return ["Expected a child of type Camera3D."]
	#
	#return 

# When triggered by an external object, sets this camera position node as the active node, after a short delay
func _on_trigger():
	if is_active:
		signal_manager.emit_signal("camera_changed", 0)
		Delay.start()

# Sets this camera node as the viewport
func set_current_node():
	Global.gameControllerRef.drone.active_cam_node = self
	Global.gameControllerRef.drone.update_cam_position()


func _on_delay_timeout() -> void:
	set_current_node()
