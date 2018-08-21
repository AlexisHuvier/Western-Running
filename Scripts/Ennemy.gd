extends RigidBody2D

const shootTimer = 100
var shoot = false

onready var bulletScene=preload("res://Scènes/Objets/BulletPistolEnnemy.tscn")
onready var camera = get_parent().get_parent().get_node("Camera2D")

func _ready():
	add_to_group("ennemy")
	pass

func _physics_process(delta):
	if shootTimer < 0 and shoot:
		get_node("ShootSound").play()
		var bullet=bulletScene.instance()
		bullet.add_to_group("ennemyBullet")
		bullet.position = Vector2(self.position.x-45,self.position.y+5)
		bullet.set_linear_velocity(Vector2(-1200,0))
		bullet.rotate(deg2rad(180))
		for i in get_parent().get_children():
			bullet.add_collision_exception_with(i)
		get_parent().add_child(bullet)
		shootTimer = 100
	shootTimer -= 1
	
	if camera.get_camera_screen_center().x >= self.position.x - 500:
		shoot = true
	else:
		shoot = false