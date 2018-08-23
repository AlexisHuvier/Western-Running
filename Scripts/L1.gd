extends Node

onready var player = get_node("Player")
onready var camera = get_node("Camera2D")
onready var ui = get_node("UI")

func _ready():
	player.level = 1
	global.playerLife = 100
	global.playerBall = 6
	global.saveGame(1)

func _process(delta):
	camera.position = Vector2(player.position.x+200, player.position.y-100)
	ui.position = Vector2(camera.get_camera_screen_center().x-515, camera.get_camera_screen_center().y-330)