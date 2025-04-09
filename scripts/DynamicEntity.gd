# DynamicEntity class used as a base interface for entities that can be modfied or triggered in real time
class_name DynamicEntity
extends Node3D

# whether or not the entity is active
@export var is_active:bool = true

#base function for triggering the entity
func _on_trigger():
	pass

# activates the entity
func _activate():
	is_active = true

# deactivates the entity
func _deactivate():
	is_active = false
