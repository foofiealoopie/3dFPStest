extends KinematicBody

onready var enemyAnimation = $EnemyAnimation

var health = 500

func _process(delta):
	if health <= 0:
		queue_free()
