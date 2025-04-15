@tool
# A node that when triggered sends it's dialog to the players message screen
class_name DialogChanger
extends DynamicEntity

# dialog to change to
@export var newDialog:Array[String] = [""]

# time before triggering given entities
@export var delay_before_trigger: float = 0.0

# whether or not this node should be able to be triggered multiple times
@export var oneShot: bool = false

# whether or not this node should trigger upon entering the scene
@export var trigger_on_start: bool = false

# array of objects to send a trigger signal to on interact
@export var trigger_on_interact: Array[DynamicEntity] = []:
	set(arr):
		trigger_on_interact = arr

var signal_manager: SignalBus = SigBus

@onready var Delay: Timer = $Timer

func _ready():
	# if not in editor
	if !Engine.is_editor_hint():
		Delay.wait_time = delay_before_trigger
		$Sprite3D.visible = false
		
		if trigger_on_start:
			_on_trigger()

func _on_trigger():
	if is_active:
		print("dialogChanger triggered!")
		if oneShot:
			is_active = false

		if delay_before_trigger > 0:
			Delay.start()
		else:
			signal_manager.emit_signal("dialog_event", newDialog)
			trigger_objects()

# when the delay timer is up, trigger given entities
func _on_timer_timeout() -> void:
	signal_manager.emit_signal("dialog_event", newDialog)
	trigger_objects()

# triggers any objects in the array of objects to trigger, as long as the objects are dynamicEntities and active
func trigger_objects():
	for obj in trigger_on_interact:
		if obj is DynamicEntity and (obj as DynamicEntity).is_active:
			(obj as DynamicEntity)._on_trigger()
