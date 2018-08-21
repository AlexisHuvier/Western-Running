extends RigidBody2D

var maxLevel = 2
var level = 0

var WALK_SPEED = 300
var JUMP_FORCE = 400
var FORCE_DECREASE = 20
var MAX_GRAVITY = 300

var grounded = false
var jumping = false
var walkLeft = false
var walkRight = false
var reverse = false
var yForce = 0

onready var IDLE = get_node("SpriteIDLE")
onready var RUN = get_node("SpriteRUN")
onready var JUMP = get_node("SpriteJUMP")

onready var bulletScene=preload("res://Scènes/Objets/BulletPistolPlayer.tscn")
var shootTimer = 0
var countball = 0
var ballreload = 0

func _ready():
	add_to_group("player")
	connect("body_entered", self, "_on_body_entered")

func _on_body_entered(body):
	if body.is_in_group("ennemy"):
		body.queue_free()
		global.playerLife -= 50
	elif body.is_in_group("final"):
		if level == maxLevel:
			get_tree().change_scene("res://Scènes/Win.tscn")
		else:
			get_tree().change_scene("res://Scènes/Niveaux/L"+str(level+1)+".tscn")

func _physics_process(delta):
	if self.position.y > get_parent().get_node("Minimum").global_position.y:
		get_tree().change_scene("res://Scènes/GameOver.tscn")
	
	if global.playerLife <= 0:
		get_tree().change_scene("res://Scènes/GameOver.tscn")
	
	if self.position.x >= get_global_mouse_position().x:
		reverse = true
	else:
		reverse = false
	
	if reverse:
		IDLE.flip_h = true
		RUN.flip_h = true
		JUMP.flip_h = true
	else:
		IDLE.flip_h = false
		RUN.flip_h = false
		JUMP.flip_h = false
	
	if !walkLeft && !walkRight:
		if jumping:
			IDLE.hide()
			RUN.hide()
			JUMP.show()
		else:
			IDLE.show()
			RUN.hide()
			JUMP.hide()
	else:
		if jumping:
			IDLE.hide()
			RUN.hide()
			JUMP.show()
		else:
			IDLE.hide()
			RUN.show()
			JUMP.hide()
	
	var shoot = Input.is_action_pressed("shoot")
	var reload = Input.is_action_pressed("reload")
	
	if ballreload==1:
		countball-=1
		if global.playerBall<6 and countball<=0:
			global.playerBall+=1
			countball=20
		if global.playerBall==6:
			ballreload=0
	
	if shoot and shootTimer <= 0 and ballreload != 1 and global.playerBall > 0:
		get_node("ShootSound").play()
		var bullet=bulletScene.instance()
		bullet.add_to_group("playerBullet")
		if reverse:
			bullet.position = Vector2(self.position.x-45,self.position.y+5)
			bullet.set_linear_velocity(Vector2(-1200,0))
			bullet.rotate(deg2rad(180))
		else:
			bullet.position = Vector2(self.position.x+52,self.position.y+5)
			bullet.set_linear_velocity(Vector2(1200,0))
		get_parent().add_child(bullet)
		shootTimer = 20
		global.playerBall -= 1
	else:
		shootTimer -= 1
		countball -= 1
		
	if reload:
		get_node("ReloadSound").play()
		ballreload = 1
	
	moveCharacter()

func moveCharacter():
	var walk_left = Input.is_action_pressed("left")
	var walk_right = Input.is_action_pressed("right")
	var jump = Input.is_action_pressed("jump")
	
	var move = self.linear_velocity
	
	yForce += FORCE_DECREASE
	if yForce > self.MAX_GRAVITY:
		yForce = self.MAX_GRAVITY
	
	if walk_left:
		if not grounded:
			move.x = -WALK_SPEED*0.75
		else:
			move.x = -WALK_SPEED
		walkLeft = true
	elif walk_right:
		if not grounded:
			move.x = WALK_SPEED*0.75
		else:
			move.x = WALK_SPEED
		walkRight = true
	else:
		move.x = 0
		walkRight = false
		walkLeft = false
	
	if self.linear_velocity.y > 0:
		jumping = false
	
	if jump and grounded:
		yForce = -JUMP_FORCE
		jumping = true
	elif grounded:
		yForce = 0
	
	move.y = yForce
	
	self.linear_velocity = move

func _on_GroundChecker_body_entered(body):
	grounded = true

func _on_GroundChecker_body_exited(body):
	grounded = false
