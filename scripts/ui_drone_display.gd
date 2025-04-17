class_name UI_DroneDisplay
extends CanvasLayer

@export var is_on:bool = true
var cursor_offset:Vector2 = Vector2.ZERO
var cursor_Sprite_offset:Vector2 = Vector2.ZERO
var cursor_pressed:bool = false

var fade_time:float = 0.05

@onready var delay1:Timer = $Timer1
@onready var delay2:Timer = $Timer2
@onready var sampleCollectionTimer:Timer = $SampleCollectionTimer
@onready var BlankScreen:ColorRect = $BlankScreen
@onready var LoadingText:Label = $LoadingText
@onready var Cursor:Node2D = $Cursor
@onready var CursorSprite:Sprite2D = $Cursor/CursorSprite2D
@onready var CompassPointer:Sprite2D = $DroneScreenOverlay/Compass/CompassSprite
@onready var SampleCollectionOverlay := $SampleCollectionOverlay
@onready var SampleProgressBar := $"SampleCollectionOverlay/VBoxContainer/BG-Color/MarginContainer/ProgressBar"
@onready var MessageNotif:Control = $MessageNotif

var signal_manager: SignalBus = SigBus

func _ready() -> void:
	signal_manager.connect("camera_changed", cam_change_anim)
	signal_manager.connect("screen_cursor_changed", set_cursor_type)
	signal_manager.connect("focus_screen", focus_screen)
	signal_manager.connect("collect_sample_start", startSampleCollection)
	
	SampleCollectionOverlay.visible = false
	
	if is_on:
		BlankScreen.visible = false
		LoadingText.visible = false
	else:
		BlankScreen.visible = true
		LoadingText.visible = false

func _process(delta: float) -> void:
	# updates compass rotation
	CompassPointer.rotation = -Global.gameControllerRef.drone.DroneCamera.global_rotation.y
	
	# updates cursor position
	Cursor.position = Global.gameControllerRef.UI.get_global_mouse_position()


# changes cursor to show that use is pressing down
func cursor_click(pressing:bool):
	if pressing && !cursor_pressed:
		#CursorSprite.modulate = Color(0.861, 0.847, 0.765)
		CursorSprite.modulate = Color(0.718, 0.696, 0.574, 0.75)
		cursor_pressed = true
		cursor_offset = Vector2(0.0,5.0)
	else: if cursor_pressed:
		CursorSprite.modulate = Color(0.718, 0.696, 0.574, 1.0)
		cursor_pressed = false
		cursor_offset = Vector2(0.0,0.0)
		
	CursorSprite.offset = cursor_Sprite_offset +  cursor_offset

func set_cursor_type(type:int):
	
	if type == 0: # default cursor
		CursorSprite.texture = load("res://resources/Textures/Sprites/CompPointerArrow1_b1.png")
		cursor_Sprite_offset = Vector2(10.0,19.0)
	else: if type == 1: # camera change sprite
		CursorSprite.texture = load("res://resources/Textures/Sprites/CompPointerArrow3_b1.png")
		cursor_Sprite_offset = Vector2.ZERO
	else: if type == 2: # room change sprite
		CursorSprite.texture = load("res://resources/Textures/Sprites/CompPointerArrow2_b1.png")
		cursor_Sprite_offset = Vector2.ZERO
	else: if type == 3: # inspect sprite
		CursorSprite.texture = load("res://resources/Textures/Sprites/CompPointerArrow4_b1.png")
		cursor_Sprite_offset = Vector2.ZERO
	
	# update offset, if needed
	CursorSprite.offset = cursor_Sprite_offset + cursor_offset

# shows or hides the message notification
func showMessageNotif(show:bool):
	if show:
		MessageNotif.visible = true
	else:
		MessageNotif.visible = false

# enables  or disables the computer mouse cursor
func focus_screen(focused:bool):
	if focused:
		Cursor.visible = true
	else:
		Cursor.visible = false

func cam_change_anim(_cam_node:CameraNode)->void:
	fade_out()

# Fades out to black
func fade_out()->void:
	BlankScreen.size = Vector2(1280, 347)
	BlankScreen.position = Vector2(0.0, 0.0)
	BlankScreen.visible = true
	LoadingText.visible = false
	is_on = false
	delay1.wait_time = fade_time
	delay1.start()
	

# Fades in from black
func fade_in()->void:
	BlankScreen.size = Vector2(1280.0, 845.0)
	BlankScreen.position = Vector2(0.0, 116.0)
	BlankScreen.visible = true
	LoadingText.visible = false
	is_on = true
	delay1.wait_time = fade_time
	delay1.start()
	var tween = create_tween()
	tween.parallel().tween_method(change_drone_bus_volume, -40, 0, 0.25).set_trans(Tween.TRANS_BOUNCE)  # re-enable audio from drone

func startSampleCollection() -> void:
	SampleCollectionOverlay.visible = true
	var tween = create_tween()
	tween.tween_property(SampleProgressBar, "custom_minimum_size", Vector2(864.0, 0.0), 6.0).from(Vector2(0.0,0.0)).set_trans(Tween.TRANS_EXPO)
	sampleCollectionTimer.start()

# After first delay
func _on_timer_timeout() -> void:
	# if screen was fading in from black
	if is_on:
		BlankScreen.visible = false
		LoadingText.visible = false
	
	# if screen was fading out to black
	else:
		var tween = create_tween()
		tween.parallel().tween_method(change_drone_bus_volume, 0, -40, 0.25).set_trans(Tween.TRANS_BACK) # mute audio from drone
		BlankScreen.size = Vector2(1280.0, 960.0)
		BlankScreen.position = Vector2(0.0, 0.0)
		LoadingText.text = ""
		LoadingText.visible = true
		delay2.wait_time = 2.0
		delay2.start()
		tween.tween_property(LoadingText, "text", ".", 0.25)
		tween.chain().tween_property(LoadingText, "text", "..", 0.25)
		tween.chain().tween_property(LoadingText, "text", "...", 0.25)
		tween.chain().tween_property(LoadingText, "text", "", 0.25)
		tween.chain().tween_property(LoadingText, "text", ".", 0.25)
		tween.chain().tween_property(LoadingText, "text", "..", 0.25)
		tween.chain().tween_property(LoadingText, "text", "...", 0.25)
		tween.chain().tween_property(LoadingText, "text", "", 0.25)
		tween.chain().tween_property(LoadingText, "text", ".", 0.25)
		tween.chain().tween_property(LoadingText, "text", "..", 0.25)
		tween.chain().tween_property(LoadingText, "text", "...", 0.25)

# Fade back in after second Delay
func _on_timer_2_timeout() -> void:
	# fade back in from black after some time
	fade_in()

# Used in Tweening
func change_drone_bus_volume(value: float):
	var index = AudioServer.get_bus_index("DroneAudio")
	AudioServer.set_bus_volume_db(index, value)


func _on_sample_collection_timer_timeout() -> void:
	SampleCollectionOverlay.visible = false
	SoundManager3D.PlaySoundQueue3D("SQ_CDing", Global.controlRoomRef.global_position)
	signal_manager.emit_signal("collect_sample_end")
