class_name UI_MapDisplay
extends CanvasLayer

# grid posions gridMap[row][column]
var gridMap: Array[Array] = []

@onready var CompassPointer := $Compass/CompassPointer
@onready var DroneIcon := $MarginContainer/MarginContainer_Grid/MapIcons/DroneIcon
@onready var mapUI := $MarginContainer/MarginContainer_Grid/VBoxContainer
@onready var sampleStatusLabel1 := $Status/SampleCollectedLabel1
@onready var sampleSPosLabel1 := $Status/SamplePosLabel1
var samplepos1:String = "S1"
@onready var sampleStatusLabel2 := $Status/SampleCollectedLabel2
@onready var sampleSPosLabel2 := $Status/SamplePosLabel2
var samplepos2:String = "S2"
@onready var sampleStatusLabel3 := $Status/SampleCollectedLabel3
@onready var sampleSPosLabel3 := $Status/SamplePosLabel3
var samplepos3:String = "S3"
var signal_manager: SignalBus = SigBus

var rng = RandomNumberGenerator.new()
@onready var GlitchTimer:Timer = $GlitchTimer
var is_endgame:bool = false

func _ready() -> void:
	var rowPos := 0
	var colPos := 0
	# populate 2D array with references to grid positions
	for row in mapUI.get_children():
		gridMap.append([])
		for sector in row.get_children():
			gridMap[rowPos].append(sector)
			
			# increment colPos
			colPos += 1
		# increment rowPos
		rowPos += 1
	
	#setDroneIconPos(Vector2(1,2))
	signal_manager.connect("icon_loc_change", setDroneIconPos)
	signal_manager.connect("end_game", setRandomMapPos)
	#print(str(gridMap))

func _process(delta: float) -> void:
	# update the compass rotation 
	if !is_endgame:
		if Global.gameControllerRef.drone:
			CompassPointer.rotation = -Global.gameControllerRef.drone.DroneCamera.global_rotation.y
	else:
		CompassPointer.rotation += deg_to_rad(1000) * delta

# moves the map icon for the drone's position to the correct spot. Coordinates start from upper left corner
func setDroneIconPos(coords: Vector2) -> void:
	#print(str(gridMap[coords.y][coords.x]) + " " + str(gridMap[coords.y][coords.x].get_parent()) )
	#var dronePosition = Vector2((gridMap[coords.y][coords.x] as ColorRect).global_position.x, (gridMap[coords.y][coords.x] as ColorRect).get_parent().global_position.y)
	#print(coords)
	DroneIcon.position = Vector2(((coords.x + 4) * 100), ((coords.y + 4) * 100) - 28)
	#print(dronePosition)

func updateSamplesStatus() -> void:
	# this is kinda messy, but it works lol
	if Global.gameControllerRef.samples_collected <= 0:
		sampleStatusLabel1.text = "▭" 
		sampleStatusLabel2.text = "▭" 
		sampleStatusLabel3.text = "▭" 
	else: if Global.gameControllerRef.samples_collected == 1:
		sampleStatusLabel1.text = "▬"
	else: if Global.gameControllerRef.samples_collected == 2:
		sampleStatusLabel2.text = "▬"
	else: if Global.gameControllerRef.samples_collected >= 3:
		sampleStatusLabel3.text = "▬"

# sets a random position on the map
func setRandomMapPos():
	is_endgame = true
	setDroneIconPos(Vector2(rng.randi_range(0-4,7-4),rng.randi_range(0-4,7-4)))
	GlitchTimer.start()
