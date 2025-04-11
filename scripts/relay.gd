@tool
# This is a Relay node. When triggered, it can relay that trigger to any given objects in its "trigger_on_interact" array.
# This is not a necessary node, but it can be helpful for organizing various triggers.
class_name Relay
extends DynamicEntity

# time before triggering given entities
@export var delay_before_trigger: float = 0.0

# whether or not this relay should be able to be triggered multiple times
@export var oneShot: bool = false

# array of objects to send a trigger signal to on interact
@export var trigger_on_interact: Array[DynamicEntity] = []:
	set(arr):
		trigger_on_interact = arr

# array of objects to set as active on interact
@export var activate_on_interact: Array[DynamicEntity] = []:
	set(arr):
		activate_on_interact = arr

# array of objects to set as inactive on interact
@export var deactivate_on_interact: Array[DynamicEntity] = []:
	set(arr):
		deactivate_on_interact = arr


@onready var Delay: Timer = $Timer

func _ready():
	# if not in editor
	if !Engine.is_editor_hint():
		Delay.wait_time = delay_before_trigger
		$Sprite3D.visible = false

func _on_trigger():
	if is_active:
		
		if oneShot:
			is_active = false
		
		if delay_before_trigger > 0:
			Delay.start()
		else:
			trigger_objects()

# when the delay timer is up, trigger given entities
func _on_timer_timeout() -> void:
	trigger_objects()

# triggers any objects in the array of objects to trigger, as long as the objects are dynamicEntities and active
func trigger_objects():
	for obj in trigger_on_interact:
		if obj is DynamicEntity and (obj as DynamicEntity).is_active:
			(obj as DynamicEntity)._on_trigger()
	
	for obj in activate_on_interact:
		if obj is DynamicEntity:
			(obj as DynamicEntity).is_active = true
	
	for obj in deactivate_on_interact:
		if obj is DynamicEntity:
			(obj as DynamicEntity).is_active = false
