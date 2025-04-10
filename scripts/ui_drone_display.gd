class_name UI_DroneDisplay
extends CanvasLayer

@export var is_on:bool = true

var fade_time:float = 0.05

@onready var delay1:Timer = $Timer1
@onready var delay2:Timer = $Timer2
@onready var BlankScreen:ColorRect = $BlankScreen
@onready var LoadingText:Label = $LoadingText

var signal_manager: SignalBus = SigBus

func _ready() -> void:
	signal_manager.connect("camera_changed", cam_change_anim)
	
	if is_on:
		BlankScreen.visible = false
		LoadingText.visible = false
	else:
		BlankScreen.visible = true
		LoadingText.visible = false

func cam_change_anim(id:int)->void:
	fade_out()
	pass

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

# After second Delay
func _on_timer_2_timeout() -> void:
	# fade back in from black after some time
	fade_in()


func change_drone_bus_volume(value: float):
	var index = AudioServer.get_bus_index("DroneAudio")
	AudioServer.set_bus_volume_db(index, value)
