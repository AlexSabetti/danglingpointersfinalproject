class_name UI_GridSquare
extends Control

var has_player:bool = false
var has_been_visited:bool = false
var is_poi:bool = false

var unexplored_color:Color = Color("#0a0c08")
var explored_color:Color = Color("#3f4134")

var droneIcon:Texture2D = load("res://resources/Textures/Sprites/CompCircle1_a1.png")
var drownArrowIcon_Up:Texture2D = load("res://resources/Textures/Sprites/CompMapArrowUp1_a1.png")
var drownArrowIcon_Down:Texture2D = load("res://resources/Textures/Sprites/CompMapArrowDown1_a1.png")
var drownArrowIcon_Left:Texture2D = load("res://resources/Textures/Sprites/CompMapArrowLeft1_a1.png")
var drownArrowIcon_Right:Texture2D = load("res://resources/Textures/Sprites/CompMapArrowRight1_a1.png")

@onready var BGColor:ColorRect = $BGSquare
@onready var PlayerIcon:Control = $BGSquare/PlayerIcon
@onready var PlayerIconSprite:Sprite2D = $BGSquare/PlayerIcon/Sprite2D

@onready var Walls:Control = $BGSquare/Walls
@onready var Wall_Up:ColorRect = $BGSquare/Walls/Wall_Up
@onready var Wall_Left:ColorRect = $BGSquare/Walls/Wall_Left
@onready var Wall_Down:ColorRect = $BGSquare/Walls/Wall_Down
@onready var Wall_Right:ColorRect = $BGSquare/Walls/Wall_Right

func _on_explored():
	BGColor.color = explored_color
	var drone:Drone = Global.gameControllerRef.drone
	
	if drone.active_map_node != null:
		Walls.visible = true
		if drone.active_map_node.north_open:
			Wall_Down.visible = false
		if drone.active_map_node.east_open:
			Wall_Right.visible = false
		if drone.active_map_node.south_open:
			Wall_Up.visible = false
		if drone.active_map_node.west_open:
			Wall_Left.visible = false

func set_has_player(b:bool):
	has_player = b
	PlayerIcon.visible = b

func set_drone_icon(type:int):
	if type == 0:
		PlayerIconSprite.texture = droneIcon
	else: if type == 1:
		PlayerIconSprite.texture = drownArrowIcon_Up
	else: if type == 2:
		PlayerIconSprite.texture = drownArrowIcon_Down
	else: if type == 3:
		PlayerIconSprite.texture = drownArrowIcon_Left
	else: if type == 4:
		PlayerIconSprite.texture = drownArrowIcon_Right
