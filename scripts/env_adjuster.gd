@tool
# This is a Relay node. When triggered, it can relay that trigger to any given objects in its "trigger_on_interact" array.
# This is not a necessary node, but it can be helpful for organizing various triggers.
class_name EnvAdjuster
extends DynamicEntity

@export var newEnvironment:Environment

# time before triggering given entities
#@export var delay_before_trigger: float = 0.0

# whether or not this relay should be able to be triggered multiple times
@export var oneShot: bool = false

# whether or not this node should trigger upon entering the scene
@export var trigger_on_start: bool = false

@onready var Delay: Timer = $Timer

func _ready():
	# if not in editor
	if !Engine.is_editor_hint():
		#Delay.wait_time = delay_before_trigger
		$Sprite3D.visible = false
		
		if trigger_on_start:
			_on_trigger()

func _on_trigger():
	if is_active:
		
		Global.global_world_env.environment = newEnvironment
		
		if oneShot:
			is_active = false
		
		
