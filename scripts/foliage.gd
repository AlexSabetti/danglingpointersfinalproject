@tool
class_name Foliage
extends Node3D

@export var foliage_Texture:Texture2D = load("res://Resources/Sprites/Reeds2_a1.png"):
	set(t):
		foliage_Texture = t
		# sets the mesh textures to the given texture
		if $MeshInstance3D_1 and $MeshInstance3D_2:
			$MeshInstance3D_1.get_surface_override_material(0).set_shader_parameter("Texture", foliage_Texture)
			$MeshInstance3D_2.get_surface_override_material(0).set_shader_parameter("Texture", foliage_Texture)
@export var meshOffset := Vector3(0.0, 0.5, 0.0):
	set(offset):
		meshOffset = offset
		if $MeshInstance3D_1 and $MeshInstance3D_2:
			$MeshInstance3D_1.position = meshOffset
			$MeshInstance3D_2.position = meshOffset
@export var meshScale := Vector3(1.0, 1.0, 1.0):
	set(scal):
		meshScale = scal
		if $MeshInstance3D_1 and $MeshInstance3D_2:
			$MeshInstance3D_1.scale = meshScale
			$MeshInstance3D_2.scale = meshScale
