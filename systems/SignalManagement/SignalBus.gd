class_name SignalBus
extends Node

# For when the player clicks a valid object
signal object_clicked(obj: ClickableObject)
signal camera_changed(cam_id: int)

# for changing the cursor apperance on the computer screen
signal screen_cursor_changed(type:int)

# for focusing or unfocusing on the computer screen
signal focus_screen(focus:bool)

# For when the player is controlling the drone
#signal turn_drone_left(pressed:bool)
#signal turn_drone_right(pressed:bool)

# For when dialog is to be displayed on the players message screen
signal dialog_event(text: String)

# for when collecting a sample
signal collect_sample_start()
signal collect_sample_end()


signal pause_game()
signal unpause_game()  

signal toggle_bar()  

signal inc_progress()
