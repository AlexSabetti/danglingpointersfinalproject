class_name UI_GridSquare
extends Control

var has_player:bool = false
var has_been_visited:bool = false
var is_poi:bool = false

var unexplored_color:Color = Color("#0a0c08")
var explored_color:Color = Color("#0a0c08b9")

var droneIcon:Texture2D = load("res://resources/Textures/Sprites/CompCircle1_a1.png")
var drownArrowIcon_Up:Texture2D = load("res://resources/Textures/Sprites/CompMapArrowUp1_a1.png")
var drownArrowIcon_Down:Texture2D = load("res://resources/Textures/Sprites/CompMapArrowDown1_a1.png")
var drownArrowIcon_Left:Texture2D = load("res://resources/Textures/Sprites/CompMapArrowLeft1_a1.png")
var drownArrowIcon_Right:Texture2D = load("res://resources/Textures/Sprites/CompMapArrowRight1_a1.png")

@onready var BGColor:ColorRect = $BGSquare
@onready var PlayerIcon:Control = $BGSquare/PlayerIcon
@onready var PlayerIconSprite:Sprite2D = $BGSquare/PlayerIcon/Sprite2D


func _on_explored():
	BGColor.color = explored_color
	pass

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
