@tool
# This is a Relay node. When triggered, it can relay that trigger to any given objects in its "trigger_on_interact" array.
# This is not a necessary node, but it can be helpful for organizing various triggers.
class_name SignalSender
extends DynamicEntity

@export var signal_to_send:String = ""

# time before triggering given entities
@export var delay_before_trigger: float = 0.0

# whether or not this relay should be able to be triggered multiple times
@export var oneShot: bool = false

var signal_manager: SignalBus = SigBus

@onready var Delay: Timer = $Timer

func _ready():
	# if not in editor
	if !Engine.is_editor_hint():
		Delay.wait_time = delay_before_trigger
		$Sprite3D.visible = false
		

func _on_trigger():
	if is_active:
		print("signalReceiver triggered")
		
		if oneShot:
			is_active = false
		
		if delay_before_trigger > 0:
			Delay.start()
		else:
			signal_manager.emit_signal(signal_to_send)

# when the delay timer is up, trigger given entities
func _on_timer_timeout() -> void:
	signal_manager.emit_signal(signal_to_send)
