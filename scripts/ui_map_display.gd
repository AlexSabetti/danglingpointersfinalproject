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
var gridSquare := preload("res://scenes/UI/ui_grid_square.tscn")
var mapScale:int = 9
var mapSquares: Array[Array] = []
@onready var MapGrid:GridContainer = $MarginContainer/MarginContainer_Grid/MapGrid

var mapPosOffset:int = 4
var currGridSquare:UI_GridSquare

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
	signal_manager.connect("icon_loc_change", updateMapPos)
	signal_manager.connect("end_game", setRandomMapPos)
	#print(str(gridMap))
	
	prepare_map()

func _process(delta: float) -> void:
	# update the compass rotation 
	if !is_endgame:
		if Global.gameControllerRef.drone:
			CompassPointer.rotation = -Global.gameControllerRef.drone.DroneCamera.global_rotation.y
	else:
		CompassPointer.rotation += deg_to_rad(1000) * delta

# sets up the map by populating the MapGrid with grid squares
func prepare_map():
	MapGrid.columns = mapScale
	for x in range(0, mapScale):
		mapSquares.append([])
		for y in range(0, mapScale):
			var MS:UI_GridSquare= gridSquare.instantiate()
			MapGrid.add_child(MS)
			mapSquares[x].append(MS)
			


func updateMapPos(c: Vector2):
	var coords:Vector2 = Vector2(c.x + mapPosOffset, c.y + mapPosOffset)
	
	# set previous square as having no player (if there was a previous square)
	if currGridSquare != null:
		# set previous grid square to no longer have the player icon
		currGridSquare.set_has_player(false)
	
	# check if new position is on the map
	# if not, put an arrow pointing in the gerneral direction of the drone.
	if (coords.y < 0):	# if off the grid to the 
		currGridSquare = mapSquares[0][coords.x] as UI_GridSquare
		currGridSquare.set_has_player(true)
		currGridSquare.set_drone_icon(1)
		
	else: if (coords.y > mapSquares.size() - 1):	# if off the grid to the 
		currGridSquare = mapSquares[mapSquares.size() - 1][coords.x] as UI_GridSquare
		currGridSquare.set_has_player(true)
		currGridSquare.set_drone_icon(2)
		
	else: if (coords.x < 0):	# if off the grid to the 
		currGridSquare = mapSquares[coords.y][0] as UI_GridSquare
		currGridSquare.set_has_player(true)
		currGridSquare.set_drone_icon(3)
		
	else: if (coords.x > mapSquares.size() - 1):	# if off the grid to the 
		currGridSquare = mapSquares[coords.y][mapSquares.size() - 1] as UI_GridSquare
		currGridSquare.set_has_player(true)
		currGridSquare.set_drone_icon(4)
		
	else: # if on the grid
		
		# set current grid square to have the player icon
		currGridSquare = mapSquares[coords.y][coords.x] as UI_GridSquare
		if !currGridSquare.has_been_visited:
			currGridSquare._on_explored()
		currGridSquare.set_has_player(true)
		currGridSquare.set_drone_icon(0)
		
	
	#setDroneIconPos(coords)

# moves the map icon for the drone's position to the correct spot. Coordinates start from upper left corner
func setDroneIconPos(coords: Vector2) -> void:
	#print(str(gridMap[coords.y][coords.x]) + " " + str(gridMap[coords.y][coords.x].get_parent()) )
	#var dronePosition = Vector2((gridMap[coords.y][coords.x] as ColorRect).global_position.x, (gridMap[coords.y][coords.x] as ColorRect).get_parent().global_position.y)
	#print(coords)
	DroneIcon.position = Vector2(((coords.x) * 100), ((coords.y) * 100) - 28)
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
