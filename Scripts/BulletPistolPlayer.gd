extends RigidBody2D

var count=100
var goto
var angle
var longueur

func _ready():
	goto = get_global_mouse_position()
	var longueur = sqrt(pow(goto.x-position.x, 2)+pow(goto.y - position.y, 2))
	set_linear_velocity(Vector2(goto.x-position.x,goto.y-position.y)*(1200/longueur))
	var longueurSIY=goto.y-position.y
	var longueurSIX=goto.x-position.x
	if atan(longueurSIX/longueurSIY) < 0:
		angle=(PI/2 - atan(longueurSIX/longueurSIY))+PI
	else:
		angle=(PI/2 - atan(longueurSIX/longueurSIY))
	angle += PI/2
	
	rotate(angle)
	add_to_group("bullet")
	connect("body_entered", self, "_on_body_entered")

func _process(delta):
	if count<=0:
		queue_free()
	
	count-=1

func _on_body_entered(body):
	if body.is_in_group("ennemy"):
		if self.is_in_group("playerBullet"):
			queue_free()
			body.queue_free()
	elif body.is_in_group("player"):
		if self.is_in_group("ennemyBullet"):
			queue_free()
			global.playerLife -= 10
	else:
		queue_free()
