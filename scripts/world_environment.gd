extends WorldEnvironment

@export var fog_on:bool = true


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.global_world_env = self
	if fog_on:
		self.environment.volumetric_fog_enabled = true
		self.environment.fog_enabled = true
