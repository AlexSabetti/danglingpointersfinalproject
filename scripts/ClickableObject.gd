@tool
# Represents an object in the scene that can be clicked with the mouse cursor. Base copied over from Hidden Object Game
class_name ClickableObject
extends DynamicEntity
@export_group("Object Specifics")
# the name of the object
@export var object_name: String
# the id of the object (could be helpful idk)
@export var obj_id: int
# the text to be displayed upon picking up the object
@export var obj_blurb: String

@export_group("Object Interaction")
# This is for when the player clicks on the item but isn't in the proper section (This would happen usually by accident). It just denies the signal unless it's true.
@export var is_interactable: bool = false:
	set(i):
		is_interactable = i
		# checks for collision shape
		for child in get_children():
			if child is CollisionShape3D:
				col_box = child as CollisionShape3D
		update_configuration_warnings()

# whether or not this node should be able to be triggered multiple times
@export var oneShot: bool = false

# array of objects to send a trigger signal to on interact
@export var trigger_on_interact: Array[DynamicEntity] = []:
	set(arr):
		trigger_on_interact = arr

var signal_manager: SignalBus = SigBus

# the collision box used for the object
@onready var col_box: CollisionShape3D

func _ready():
	set_process_input(true)
	signal_manager.connect("camera_changed", _activate_in_scene)
	#signal_manager.connect("inc_progress", lower_progress_requirement)
	
	# checks for collision shape
	for child in get_children():
		if child is CollisionShape3D:
			col_box = child as CollisionShape3D
	
	if col_box != null:
		col_box.debug_color = Color("008ee5", 1.0)
	
	update_configuration_warnings()

func _get_configuration_warnings():
	# sends warning in editor if no collision shape is present as a child of this node
	if is_interactable and col_box == null:
		return ["Expected CollisionShape3D child"]
	return 

func _activate_in_scene(id_to_activate: int):
	if id_to_activate == obj_id:
		is_interactable = true
	else:
		is_interactable = false

func _on_trigger():
	if is_active && trigger_on_interact.size() > 0:
		if oneShot:
			is_active = false
		
		trigger_objects()

# triggers any objects in the array of objects to trigger, as long as the objects are dynamicEntities and active
func trigger_objects():
	for obj in trigger_on_interact:
		if obj is DynamicEntity and (obj as DynamicEntity).is_active:
			(obj as DynamicEntity)._on_trigger()

#func lower_progress_requirement():
	#if progress_requirement > 0:
		#progress_requirement -= 1
	#else:
		#progress_requirement = 0

#func finish_pickup():
	#get_parent().visible = false
	#queue_free()
