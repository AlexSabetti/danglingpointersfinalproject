extends Node3D
class_name GameController

#@export var progress_order: Array = ["logbook", "fishing rod", "polaroid photos", "ship keys", "decoy duck", "spyglass", "boot", "cassette tape", "compass"]


var mouse: Vector2 = Vector2.ZERO
const MAX_DIST = 800

var signal_manager: SignalBus = SigBus
var paused: bool = false


@export_category("CameraControls")
@export var player_cam: Camera3D # camera of the player's character
@export var drone:Drone # drone to be used by the player
var is_screen_focused:bool = false
@export var camAccel: float = 0.5
@export var turnSpeed := 0.25
var twist_input: float = 0.0
var min_h_rotation: float = -45.0
var max_h_rotation: float = 45.0
# current object being hovered over by the player
var cur_target_object

@export_category("computer screen")
@export var VirtualScreenViewport: SubViewport
@export var MessageScreenUI: UI_MsgDisplay
@export var DroneScreenUI: UI_DroneDisplay
@export var MapScreenUI: UI_MapDisplay
@export var screenInteractionEnabled:bool = true

# game progression
var goal_room:MapNode # next goal room where the player needs to collect samples
var samples_collected:int = 0 # number of samples collected
var is_collecting_samples:bool = false
var poi_encounters:int = 0 # number of points of interest encountered

@onready var UI = $CanvasLayer_hud/ui_hud

func _ready():
	Global.gameControllerRef = self
	
	signal_manager.connect("collect_sample_end", finish_collecting_sample)
	
	#signal_manager.emit_signal("camera_changed", 1)
	#UI._update_requests(["- find " + progress_order[0], "- find " + progress_order[1], "- find " + progress_order[2]])
	

func _process(delta: float):
	# Check for camera movement inputs
	camera_movement(delta)
	
	# check if user is hovering over an object
	if !paused:
		if is_screen_focused && VirtualScreenViewport != null:
			get_mouse_pos(mouse, VirtualScreenViewport)
		else:
			get_mouse_pos(mouse, get_viewport())
		
		# drone flashlight controls
		if Input.is_action_just_pressed("toggle_light") && drone != null:
			drone.toggle_light()
		
		# collect samples for room if correct room to do so
		if Input.is_action_just_pressed("enter_key"):
			collectSamples()
		
		# message scrolling button press sound
		if Input.is_action_just_pressed("scroll_up"):
			SoundManager3D.PlaySoundPool3D("SP_KeyHold", Global.controlRoomRef.global_position)
		if Input.is_action_just_pressed("scroll_down"):
			SoundManager3D.PlaySoundPool3D("SP_KeyHold", Global.controlRoomRef.global_position)
			
		# message scrolling
		if Input.is_action_pressed("scroll_up"):
			MessageScreenUI.scroll_up()
		if Input.is_action_pressed("scroll_down"):
			MessageScreenUI.scroll_down()
		

func _input(event):
	if event.is_action_pressed("ui_cancel") && !UI.settings_locked:
		toggle_pause_menu()
	
	if event is InputEventMouseMotion:
		mouse = event.position
	if event is InputEventMouseButton:
		var mouse_event: InputEventMouseButton = event
		if !paused and !mouse_event.pressed and mouse_event.button_index == MOUSE_BUTTON_LEFT:
			interact()
			# moved mouse detection to process to include detecting hovering over things
			#get_mouse_pos(mouse, get_viewport())
			#if VirtualScreenViewport != null && is_screen_focused:
				#get_mouse_pos(mouse, VirtualScreenViewport)

func camera_movement(delta: float):
	if Input.is_action_just_pressed("rotate_left") or Input.is_action_just_pressed("rotate_right"):
		SoundManager3D.PlaySoundPool3D("SP_KeyHold", Global.controlRoomRef.global_position)
		
	# accelerate camera turn
	if Input.is_action_pressed("rotate_left") && !Input.is_action_pressed("rotate_right") && twist_input >= 0:
		twist_input += camAccel * delta
	else: if Input.is_action_pressed("rotate_right") && !Input.is_action_pressed("rotate_left")  && twist_input <= 0:
		twist_input -= camAccel * delta
	# deccelerate camera turn
	else:
		if (twist_input > 0):
			twist_input -= camAccel * delta * 1.5
		else: if (twist_input < 0):
			twist_input += camAccel * delta * 1.5
		if abs(twist_input) < 0.01:
			twist_input = 0
		
	twist_input = clamp(twist_input, -turnSpeed, turnSpeed)
	
	drone.DroneCamera.rotate_y(deg_to_rad(twist_input))
	
	# limits degrees of rotation for drone camera
	#if rad_to_deg(drone.DroneCamera.rotation.y) <  min_h_rotation:
		#drone.DroneCamera.rotation.y = deg_to_rad(min_h_rotation)
		#twist_input = 0
	#else: if rad_to_deg(drone.DroneCamera.rotation.y) >  max_h_rotation:
		#drone.DroneCamera.rotation.y = deg_to_rad(max_h_rotation)
		#twist_input = 0
	
	# When the lean forward button is pressed, lerp the camera to focus on the computer screen, and focuses the computers audio as wellw
	if Input.is_action_pressed("lean_forward") && !is_screen_focused:
		focusScreen()
	# When the lean back button is pressed, lerp the camera to zooom out from the computer screen
	else: if Input.is_action_pressed("lean_back") && is_screen_focused:
		unfocusScreen()

func focusScreen():
	is_screen_focused = true
	signal_manager.emit_signal("focus_screen", true)
	SoundManager3D.PlaySoundPool3D("SP_KeyHold", Global.controlRoomRef.global_position)
	var tween = create_tween()
	tween.tween_property(player_cam, "position", Vector3(-0.360, 2.41, 1.241), 1.0).set_trans(Tween.TRANS_CUBIC)
	tween.parallel().tween_property(player_cam, "rotation", Vector3(0.0, deg_to_rad(-90.0), 0.0), 1.0).set_trans(Tween.TRANS_CUBIC)
	tween.parallel().tween_method(change_room_bus_volume,-4, -20, 1.0).set_trans(Tween.TRANS_CUBIC)
	tween.parallel().tween_method(change_speaker_bus_volume,-20, -4, 1.0).set_trans(Tween.TRANS_CUBIC)

func unfocusScreen():
	is_screen_focused = false
	signal_manager.emit_signal("focus_screen", false)
	SoundManager3D.PlaySoundPool3D("SP_KeyHold", Global.controlRoomRef.global_position)
	var tween = create_tween()
	tween.tween_property(player_cam, "position", Vector3(-0.809, 2.311, 1.287), 1.0).set_trans(Tween.TRANS_CUBIC)
	tween.parallel().tween_property(player_cam, "rotation", Vector3(0.0, deg_to_rad(-80.0), 0.0), 1.0).set_trans(Tween.TRANS_CUBIC)
	tween.parallel().tween_method(change_room_bus_volume,-20, -4, 1.0).set_trans(Tween.TRANS_CUBIC)
	tween.parallel().tween_method(change_speaker_bus_volume,-4, -20, 1.0).set_trans(Tween.TRANS_CUBIC)

# Gets the mouse positon and checks if a clicable objects was cliked. If so, it emits an object_clicked signal for tha object
func get_mouse_pos(mouse_loc: Vector2, viewport:Viewport):
	var start = viewport.get_camera_3d().project_ray_origin(mouse_loc)
	var end = viewport.get_camera_3d().project_position(mouse_loc, MAX_DIST)
	var space_state = get_world_3d().direct_space_state

	var para = PhysicsRayQueryParameters3D.new()
	para.from = start
	para.to = end
	
	var result = space_state.intersect_ray(para)
	if result.size() > 0 && result.get("collider") != null:
		var obj = result.get("collider")
		# if the object is a DynamicEntity, emit the signal
		if obj is DynamicEntity:
			# only set value if not already set
			if cur_target_object != obj && obj.is_active == true:
				cur_target_object = obj
				print("hovered over: " + str(obj))
				# change cursor icon type
				if cur_target_object is CameraChangeObject && !(cur_target_object as CameraChangeObject).isRoomChanger:
					UI.set_cursor_type(1)
				else: if cur_target_object is CameraChangeObject  && (cur_target_object as CameraChangeObject).isRoomChanger:
					UI.set_cursor_type(2)
				else: if cur_target_object is ClickableObject:
					UI.set_cursor_type(3)
				
		# if the object is NOT a DynamicEntity, log current target object as NULL
		else: if cur_target_object != null:
			cur_target_object = null
			print("no longer hovered over anything of value")
			UI.set_cursor_type(0)
	# if no colliders are caught by the ray cast, log the current target object as NULL
	else: if cur_target_object != null:
		cur_target_object = null
		print("nothin hovered over")
		UI.set_cursor_type(0)

	
# Attempts to interact with the currently hovered over object
func interact() -> void:
	if cur_target_object != null && screenInteractionEnabled:
		if cur_target_object is ClickableObject:
			print(cur_target_object)
			var click_obj: ClickableObject = cur_target_object
			if click_obj.is_interactable:
				signal_manager.emit_signal("object_clicked", cur_target_object)
				click_obj._on_trigger()
				SoundManager3D.PlaySoundQueue3D("SQ_CDing", Global.controlRoomRef.global_position)
				#mark_off(click_obj)
		if cur_target_object is CameraChangeObject && is_screen_focused == true && !is_collecting_samples && DroneScreenUI.is_on:
			print(cur_target_object)
			var click_obj: CameraChangeObject = cur_target_object
			if click_obj.is_interactable:
				signal_manager.emit_signal("object_clicked", cur_target_object)
				click_obj._on_trigger()
				SoundManager3D.PlaySoundQueue3D("SQ_CFink", Global.controlRoomRef.global_position)
				#mark_off(click_obj)

# begins the sample collection process for the room you are in
func collectSamples() -> void:
	# check if in correct "goal" room
	#if goal_room != null && goal_room == drone.active_map_node && !is_collecting_samples:
	if !is_collecting_samples && DroneScreenUI.is_on:
		is_collecting_samples = true
		signal_manager.emit_signal("collect_sample_start")
		SoundManager3D.PlaySoundQueue3D("SQ_CFink", Global.controlRoomRef.global_position)
		SoundManager3D.PlaySoundPool3D("SP_KeyPress", Global.controlRoomRef.global_position)

# when the collect_samples_end signal is recieved
func finish_collecting_sample() -> void:
	is_collecting_samples = false
	samples_collected += 1
	MapScreenUI.updateSamplesStatus()
	

# marks the given object as found and removes it from the progress order list
#func mark_off(obj: ClickableObject):
	#print("clicked")
	#signal_manager.emit_signal("inc_progress")
	#
	## find index of clicked item in progress order list
	#var idx_to_remove :int= -1
	#var temp := 0
	#for name in progress_order:
		#if name == obj.object_name:
			#idx_to_remove = temp
			#break
		#temp += 1
		#
	## removes item at given index if found
	#if idx_to_remove != -1:
		#progress_order.remove_at(idx_to_remove)
		##print("object [" + obj.object_name + "] removed from progress_order list at " + str(idx_to_remove))
		#print("progress_order: " + str(progress_order))
	#else:
		#print("can not find object '" + obj.object_name + "' in progress_order list.")
	#
	#progress_order.remove_at(0)
	
	# checks if there's any objects left
	#if progress_order.size() > 0:
		## this feels like a weird way to do it, but eh...
		## adds top 3 objects from progress_order array to requests array and updates the requests
		#var requests: Array = []
		#var count := 0
		#for item in progress_order:
			#requests.push_back(("- find " + item))
			#count += 1
			#if count >= 3:
				#break
			#
		#UI._update_requests(requests)
	#else: # if no objects are left, win game
		#UI._update_requests(["- leave ship"])
		#win_game()
		
	#obj.finish_pickup()
	## update object blurb to display
	#UI._update_blurb(obj.obj_blurb)

func toggle_pause_menu() -> void:
	if paused: # if currently paused, toggle pause menu OFF
		paused = false
		signal_manager.emit_signal("unpause_game")
	else:	# if not already paused, toggle pause menu ON
		paused = true
		signal_manager.emit_signal("pause_game")
		if is_screen_focused:
			unfocusScreen()

# for use in tweens
func change_room_bus_volume(value: float):
	var index = AudioServer.get_bus_index("ControlRoom")
	AudioServer.set_bus_volume_db(index, value)
# for use in tweens
func change_speaker_bus_volume(value: float):
	var index = AudioServer.get_bus_index("ComputerSpeaker")
	AudioServer.set_bus_volume_db(index, value)

# function for when the player beats the game
func win_game() -> void:
	print("you win!")
	
	Global.gameWon = true
	
