@tool
class_name FishSchool
extends DynamicEntity

@export var fishSprite:Texture2D = load("res://resources/Textures/Sprites/GreyFish1_a1.png"):
	set(tex):
		fishSprite = tex
		#if has_node("Path3D/PathFollow3D/FishParticles3D"):
			#print("setting fishies!!")
			#$Path3D/PathFollow3D/FishParticles3D.mesh.surface_0.set_instance_shader_parameter("tex", fishSprite)
@export var speed:float = 0.1

@onready var pathFollow := $Path3D/PathFollow3D
@onready var fishParticles := $Path3D/PathFollow3D/FishParticles3D

func _ready() -> void:
	
	#fishParticles.mesh.surface_0.set_instance_shader_parameter("tex", fishSprite)
	pass

func _process(delta:float) -> void:
	if is_active:
		pathFollow.progress_ratio += delta * speed
		if pathFollow.progress_ratio > 1.0:
			pathFollow.progress_ratio = 0
