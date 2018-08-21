extends RigidBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var kill = false

func _ready():
	add_to_group("caisse")


func _on_RigidBody2D_body_entered(body):
	if body.is_in_group("playerBullet"):
		if kill:
			add_collision_exception_with(body)
		else:
			body.queue_free()
			kill = true
			get_node("SpriteBREAK").play("default")
	if body.is_in_group("player") and kill:
		add_collision_exception_with(body)
		add_collision_exception_with(body.get_node("GroundChecker"))
		add_collision_exception_with(body.get_node("GroundCollision"))
	if body.is_in_group("ennemyBullet"):
		if kill:
			add_collision_exception_with(body)

func _on_SpriteBREAK_animation_finished():
	queue_free()
