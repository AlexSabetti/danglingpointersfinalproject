class_name SignalBus
extends Node

# For when the player clicks a valid object
signal object_clicked(obj: ClickableObject)
signal camera_changed(cam_id: int)

signal pause_game()
signal unpause_game()  

signal toggle_bar()  

signal inc_progress()
