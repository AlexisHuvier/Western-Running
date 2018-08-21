extends RigidBody2D

var count=100

func _ready():
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
