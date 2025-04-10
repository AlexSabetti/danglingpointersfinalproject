@tool
extends DynamicEntity

@export var fishSprite:Texture2D 
@export var speed:float = 1.0

@onready var pathFollow := $Path3D/PathFollow3D
@onready var fishParticles := $Path3D/PathFollow3D/FishParticles3D

func _ready() -> void:
	
	pass
	

func _process(delta:float) -> void:
	if is_active:
		pathFollow.progress_ratio += delta * speed
		if pathFollow.progress_ratio > 1.0:
			pathFollow.progress_ratio = 0
