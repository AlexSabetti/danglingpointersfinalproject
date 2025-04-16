class_name UI_MsgDisplay
extends CanvasLayer

@export_category("text settings")
var characterName: String = "Jhonny"
# the current text to be displayed by the dialogbox
@export var dialogueQueue : Array[String] = []
var currentText: String = ""
# current index position of text
var letterIdx := 0
# Size of the text
@export var textSize := 100
# Time between letters being printed
@export var textSpeed := 0.075:
	set(speed):
		textSpeed = speed
# how many letters must pass for the talk sound to play
@export var talkSoundFrequency := 3:
	set(freq):
		talkSoundFrequency = freq
var talkFreqCount := 0
@export var talkSoundPoolName:String = "SP_Voice"
@export var SoundSourcePos:Vector3 = Vector3.ZERO
@export var continuousText:bool = true # if true, new text is added onto previously existing text

# whether or not the dialogbox is finished displaying all letters of current text
var dialogFinished := true
# whether or not the dialog is active
var isDialogBoxActive := false

var shortPause := false

var signal_manager: SignalBus = SigBus

@onready var TextBox := $MarginContainer/VBoxContainer/MarginContainer/ScrollContainer/TextBox
@onready var scrollContainer := $MarginContainer/VBoxContainer/MarginContainer/ScrollContainer
@onready var LetterTimer := $LetterTimer

func _ready() -> void:
	signal_manager.connect("dialog_event", queueDialog)
	LetterTimer.wait_time = textSpeed

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass



# the start of a dialog sequence
func startDialog() -> void:
	#TextBox.add_theme_font_size_override("normal_font_size", textSize)
	if dialogueQueue.size() > 0:
		# pop current text from queuedText array
		currentText = dialogueQueue.pop_front()
		talkFreqCount = talkSoundFrequency - 1
		dialogFinished = false
		letterIdx = -1
		LetterTimer.wait_time = textSpeed * 6.0 # short pause before first letter
	
		if continuousText:
			TextBox.set_text(TextBox.text + "\n[color=#9f8464]" + characterName + ":[/color] ")
	
		LetterTimer.start()
	signal_manager.emit_signal("dialog_notif")


# update the current queued dialog
func queueDialog(textArray:Array[String]) -> void:
	# if dialog is still in progress, skip to end of dialogue and quickly 
	# put out the rest of the currently queued text to make room for the new queue.
	if !dialogFinished:
		dialogFinished = true
		if continuousText:
			TextBox.set_text(TextBox.text + currentText.right(-(letterIdx + 1)) + "\n")
			# if there's still more text already in the queue, flush it out
			if dialogueQueue.size() > 0:
				for t in dialogueQueue:
					TextBox.set_text(TextBox.text + "\n[color=#9f8464]" + characterName + ":[/color] " + t + "\n")
					dialogueQueue.pop_front()
			TextBox.set_text(TextBox.text + "[color=#3a3123]  ------------------------------[/color]")
			scroll_to_bottom()
	
	# add new dialog to the queued text array
	for t in textArray:
		dialogueQueue.append(t)

	letterIdx = 0
	startDialog()
	



# Set the text box to have the queued text, up to the current text index
func continueDialog() -> void:
	# keep going if not done yet
	if letterIdx < currentText.length() && !dialogFinished:

		# if text is continuous, add next char onto end of current text
		if continuousText:
			TextBox.set_text(TextBox.text + currentText[letterIdx])
		else:
			TextBox.set_text("[color=#9f8464]" + characterName + ":[/color] " + currentText.left(letterIdx + 1))
	
		# play talk sound whenever the talkSoundFrequency value is reached 
		# and current character is not a puctuation
		if talkFreqCount >= talkSoundFrequency && !isPunctuation(currentText[letterIdx]):
			SoundManager3D.PlaySoundPool3D(talkSoundPoolName, SoundSourcePos)
			talkFreqCount = 0 # reset counter
	
		# retart letterTimer
		if isPunctuation(currentText[letterIdx]):
			LetterTimer.wait_time = textSpeed * 3.0 # longer pause for punctuation
			shortPause = true
		else:
			if shortPause:
				shortPause = false
			LetterTimer.wait_time = textSpeed
		LetterTimer.start()
		scroll_to_bottom()
	else:
		finishDialog()

func finishDialog() -> void:
	letterIdx = 0
	dialogFinished = true
	if continuousText:
		# if there's still more dialogue queued, start the next dialogue
		if dialogueQueue.size() > 0:
			TextBox.set_text(TextBox.text + "\n")
			startDialog()
		else:
			TextBox.set_text(TextBox.text + "\n[color=#3a3123]  ------------------------------[/color]")
	else:
		pass
	
	scroll_to_bottom()

# on letter timer complete
func _on_letter_timer_timeout() -> void:
	if !dialogFinished:
		# increase text index by 1
		letterIdx += 1
		#print(letterIdx, "/", queuedText.length())
		talkFreqCount += 1
		continueDialog()

# checks if the given character is a punctuation mark
func isPunctuation(ch:String) -> bool:
	if ch == "." || ch == "," || ch == "!" || ch == "?":
		return true
	else:
		return false


func scroll_up():
	#print("scroll up")
	scrollContainer.scroll_vertical -= 10
func scroll_down():
	#print("scroll down")
	scrollContainer.scroll_vertical += 10
func scroll_to_bottom():
	scrollContainer.scroll_vertical += 1000
