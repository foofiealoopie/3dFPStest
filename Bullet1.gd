extends RigidBody

var shoot = false

var DAMAGE = 100

onready var Bullet = $Area

func _ready():
	set_as_toplevel(true)
	
func _physics_process(delta):
	if shoot:
		apply_impulse(transform.basis.z, -transform.basis.z)


func _on_Area_body_entered(body):
	if body.is_in_group("Enemy"):
		queue_free()
		body.health -= DAMAGE
		body.enemyAnimation.play("EnemyDamage")
	elif body.is_in_group("Skybox"):
		queue_free()
	elif body.is_in_group("Floor"):
		queue_free()
