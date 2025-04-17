@tool
class_name Foliage
extends Node3D

@export var foliage_Texture:Texture2D = load("res://resources/Textures/Sprites/Reeds2_a1.png"):
	set(t):
		foliage_Texture = t
		# sets the mesh textures to the given texture
		if has_node("MeshInstance3D"):
			$MeshInstance3D.get_surface_override_material(0).set_shader_parameter("Texture", foliage_Texture)
@export var emission_Texture:Texture2D = null:
	set(t):
		emission_Texture = t
		# sets the emission textures to the given texture
		if has_node("MeshInstance3D") && emission_Texture != null:
			$MeshInstance3D.get_surface_override_material(0).set_shader_parameter("EmissionTexture", emission_Texture)
@export var emission_amount:float = 0.0:
	set(e):
		emission_amount = e
		if has_node("MeshInstance3D"):
			$MeshInstance3D.get_surface_override_material(0).set_shader_parameter("EmissionAmount", emission_amount)
@export var sway_amount:float = 0.1:
	set(s):
		sway_amount = s
		if has_node("MeshInstance3D"):
			$MeshInstance3D.get_surface_override_material(0).set_shader_parameter("sway_amount_x", sway_amount)
@export var sway_speed:float = 0.3:
	set(s):
		sway_speed = s
		if has_node("MeshInstance3D"):
			$MeshInstance3D.get_surface_override_material(0).set_shader_parameter("sway_speed", sway_speed)
@export var meshOffset := Vector3(0.0, 0.5, 0.0):
	set(offset):
		meshOffset = offset
		if has_node("MeshInstance3D"):
			$MeshInstance3D.position = meshOffset
@export var meshScale := Vector3(1.0, 1.0, 1.0):
	set(scal):
		meshScale = scal
		if has_node("MeshInstance3D"):
			$MeshInstance3D.scale = meshScale
