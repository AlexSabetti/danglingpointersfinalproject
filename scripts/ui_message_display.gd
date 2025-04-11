class_name UI_MsgDisplay
extends CanvasLayer

@export_category("text settings")
var characterName: String = "Jhonny"
# the current text to be displayed by the dialogbox
@export var queuedText := "Testing testing 1 2 3... Is this working?"
# current index position of text
var letterIdx := 0
# Size of the text
@export var textSize := 100
# Time between letters being shown
@export var textSpeed := 0.075:
	set(speed):
		textSpeed = speed
@export var textScaler := 1.75
@export var talkSoundFrequency := 3:
	set(freq):
		talkSoundFrequency = freq
var talkFreqCount := 0
@export var talkSoundPoolName:String = "SP_Voice"
@export var SoundSourcePos:Vector3 = Vector3.ZERO

# whether or not the dialogbox is finished displaying all letters of current text
var dialogFinished := true
# whether or not the dialog is active
var isDialogBoxActive := false

var shortPause := false

var signal_manager: SignalBus = SigBus

@onready var TextBox := $MarginContainer/VBoxContainer/TextBox
@onready var LetterTimer := $LetterTimer

func _ready() -> void:
	signal_manager.connect("dialog_event", queueDialog)
	LetterTimer.wait_time = textSpeed

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass



# the start of a dialog sequence
func startDialog() -> void:
	TextBox.add_theme_font_size_override("normal_font_size", textSize)
	talkFreqCount = talkSoundFrequency - 1
	dialogFinished = false
	letterIdx = 0
	continueDialog()
	


# update the current queued dialog text
func queueDialog(text:String) -> void:
	queuedText = text
	letterIdx = 0
	startDialog()



# Set the text box to have the queued text, up to the current text index
func continueDialog() -> void:
	# keep going if not done yet
	if letterIdx < queuedText.length():
		# get text up to the current text index
		#displayedText = queuedText.left(letterIdx)
		TextBox.set_text(characterName + ": " + queuedText.left(letterIdx + 1))
		#print("dialog: ", queuedText.left(letterIdx + 1))
	
		# play talk sound whenever the talkSoundFrequency value is reached 
		# and current character is not a puctuation
		if talkFreqCount >= talkSoundFrequency && !isPunctuation(queuedText[letterIdx]):
			SoundManager3D.PlaySoundPool3D(talkSoundPoolName, SoundSourcePos)
			talkFreqCount = 0 # reset counter
	
		# retart letterTimer
		if isPunctuation(queuedText[letterIdx]):
			LetterTimer.wait_time = textSpeed * 3.0 # longer pause for punctuation
			shortPause = true
		else:
			if shortPause:
				shortPause = false
			LetterTimer.wait_time = textSpeed
		LetterTimer.start()
	else:
		letterIdx = 0
		dialogFinished = true

# on letter timer complete
func _on_letter_timer_timeout() -> void:
	# increase text index by 1
	letterIdx += 1
	#print(letterIdx, "/", queuedText.length())
	talkFreqCount += 1
	if !dialogFinished:
		continueDialog()

# checks if the given character is a punctuation mark
func isPunctuation(ch:String) -> bool:
	if ch == "." || ch == "," || ch == "!" || ch == "?":
		return true
	else:
		return false
