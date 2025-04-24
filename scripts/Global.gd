extends Node

# global reference to active gameController
var gameControllerRef:GameController
# global reference to control room
var controlRoomRef:ControlRoom
# whether or not the game is won yet
var gameWon:bool = false

var global_world_env : WorldEnvironment

# game settings
var global_volume: float = 0.25
var global_brightness: float = 0.66
var global_camera_wobble: bool = true
