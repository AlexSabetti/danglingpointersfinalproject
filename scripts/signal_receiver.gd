@tool
# This is a Relay node. When triggered, it can relay that trigger to any given objects in its "trigger_on_interact" array.
# This is not a necessary node, but it can be helpful for organizing various triggers.
class_name SignalReceiver
extends DynamicEntity

@export var signal_to_await:String = ""

# time before triggering given entities
@export var delay_before_trigger: float = 0.0

# whether or not this relay should be able to be triggered multiple times
@export var oneShot: bool = false

## whether or not this node should trigger upon entering the scene
#@export var trigger_on_start: bool = false

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
		
		# connect trigger to given signal
		if signal_to_await != null && signal_to_await != "":
			signal_manager.connect(signal_to_await, receivedSignal_p1)
			signal_manager.connect(signal_to_await, receivedSignal)
			print("signalReceiver Connected to " + signal_to_await)
		
		
		#if trigger_on_start:
			#_on_trigger()

func receivedSignal_p1(_a):
	_on_trigger()
	
func receivedSignal():
	_on_trigger()

func _on_trigger():
	if is_active:
		print("signalReceiver triggered")
		
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
