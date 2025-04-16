class_name UI_MapDisplay
extends CanvasLayer

# grid posions gridMap[row][column]
var gridMap: Array[Array] = []

@onready var CompassPointer := $Compass/CompassPointer
@onready var DroneIcon := $MarginContainer/MarginContainer_Grid/MapIcons/DroneIcon
@onready var mapUI := $MarginContainer/MarginContainer_Grid/VBoxContainer
@onready var sampleStatusLabel := $Status/SamplesCollectedLabel

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
	
	setDroneIconPos(Vector2(1,2))
	#print(str(gridMap))

func _process(delta: float) -> void:
	# update the compass rotation 
	if Global.gameControllerRef.drone:
		CompassPointer.rotation = -Global.gameControllerRef.drone.DroneCamera.global_rotation.y

# moves the map icon for the drone's position to the correct spot. Coordinates start from upper left corner
func setDroneIconPos(coords: Vector2) -> void:
	#print(str(gridMap[coords.y][coords.x]) + " " + str(gridMap[coords.y][coords.x].get_parent()) )
	#var dronePosition = Vector2((gridMap[coords.y][coords.x] as ColorRect).global_position.x, (gridMap[coords.y][coords.x] as ColorRect).get_parent().global_position.y)
	DroneIcon.global_position = Vector2((coords.y * 100), (coords.x * 100) - 28)
	#print(dronePosition)

func updateSamplesStatus() -> void:
	# this is kinda messy, but it works lol
	if Global.gameControllerRef.samples_collected <= 0:
		sampleStatusLabel.text = "▭\n▭\n▭"
	else: if Global.gameControllerRef.samples_collected == 1:
		sampleStatusLabel.text = "▬\n▭\n▭"
	else: if Global.gameControllerRef.samples_collected == 2:
		sampleStatusLabel.text = "▬\n▬\n▭"
	else: if Global.gameControllerRef.samples_collected >= 3:
		sampleStatusLabel.text = "▬\n▬\n▬"
