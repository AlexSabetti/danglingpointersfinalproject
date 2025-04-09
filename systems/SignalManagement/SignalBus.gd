class_name SignalBus
extends Node

# For when the player clicks a valid object
signal object_clicked(obj: ClickableObject)
signal camera_changed(cam_id: int)

# For when the player is controlling the drone
signal turn_drone_left(pressed:bool)
signal turn_drone_right(pressed:bool)

# For when dialog is to be displayed on the players message screen
signal dialog_event(text: String)

signal pause_game()
signal unpause_game()  

signal toggle_bar()  

signal inc_progress()
