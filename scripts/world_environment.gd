extends WorldEnvironment

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.global_world_env = self
	self.environment.volumetric_fog_enabled = true
