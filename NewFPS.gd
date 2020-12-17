extends KinematicBody

#NOTES
#Change b.mass to change bullet travel speed. Low num = fast and high num = slow


var melee_damage = 250

var speed = Global.globalspeed
var h_acceleration = 8
var gravity = 20
var jump = 10
var full_contact = true
var canFire = true


onready var floating_text = preload("FloatingText.tscn")

var mouse_sensitivity = 0.3

var direction = Vector3()
var h_velocity = Vector3()
var movement = Vector3()
var gravity_vec = Vector3()

var current_weapon = 1

onready var head = $Head
onready var ground_check = $GroundCheck
onready var aimcast = $Head/Camera/AimCast
onready var muzzle = $Head/Gun/Muzzle
onready var muzzle2 = $Head/Camera/Hand/Sniper/Muzzle2
onready var bullet = preload("res://Bullet.tscn")
onready var anim = $AnimationPlayer2 #The 2 angles : upright = -10.89,0,0 down = -70,10,10
onready var hitbox = $Head/Camera/Hitbox
onready var weapon1 = $Head/Gun
onready var weapon2 = $Head/Camera/MeleeWeapon
onready var weapon3 = $Head/Camera/Hand/Sniper
onready var sniperTime = $ShotTimer


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
		head.rotate_x(deg2rad(-event.relative.y * mouse_sensitivity))
		head.rotation.x = clamp(head.rotation.x, deg2rad(-80), deg2rad(80))
		
func melee():
	if Input.is_action_just_pressed("fire") and current_weapon == 2:
		if not anim.is_playing():
			anim.play("swordswing")
			get_node("AnimationPlayer2").queue("Return") #plays return animation
			for body in hitbox.get_overlapping_bodies(): #gets collision object
				if body.is_in_group("Enemy"): #tests if body is "Enemy"
					body.enemyAnimation.play("EnemyDamage")
					body.health -= melee_damage
		
func weapon_select():
	
	if Input.is_action_just_pressed("weapon1"):
		current_weapon = 1
		Global.globalweapon = 1
	elif Input.is_action_just_pressed("weapon2"):
		current_weapon = 2
		Global.globalweapon = 2
	elif Input.is_action_just_pressed("weapon3"):
		current_weapon = 3
		Global.globalweapon = 3

	if current_weapon == 1:
		weapon1.visible = true
		weapon2.visible = false
		weapon3.visible = false
	elif current_weapon == 2:
		weapon1.visible = false
		weapon2.visible = true
		weapon3.visible = false
	elif current_weapon == 3:
		weapon1.visible = false
		weapon2.visible = false
		weapon3.visible = true
		
func _physics_process(delta):
	
	
	direction = Vector3() #keeps speed at 0 if not moving
	weapon_select()
	melee()
	
	
	if Input.is_action_just_pressed("fire") and current_weapon == 1:
		anim.play("gunfire")
		if aimcast.is_colliding():
			var b = bullet.instance()
			b.DAMAGE = 100
			b.mass = .5
			muzzle.add_child(b)
			b.look_at(aimcast.get_collision_point(), Vector3.UP)
			b.shoot = true
			
	if Input.is_action_just_pressed("fire") and current_weapon == 3 and canFire:
		anim.play("sniperFire")
		if aimcast.is_colliding():
			var b = bullet.instance()
			b.DAMAGE = 500
			b.mass = .1
			muzzle2.add_child(b)
			b.look_at(aimcast.get_collision_point(), Vector3.UP)
			b.shoot = true
			canFire = false
			sniperTime.start()
			
	if sniperTime.is_stopped():
		canFire = true
	
	if ground_check.is_colliding():
		full_contact = true
	else:
		full_contact = false
	
	if not is_on_floor():
		gravity_vec += Vector3.DOWN * gravity * delta
	elif is_on_floor() and full_contact:
		gravity_vec = -get_floor_normal() * gravity
	else:
		gravity_vec = -get_floor_normal()
		
	if Input.is_action_just_pressed("jump") and is_on_floor() or (ground_check.is_colliding()):
		gravity_vec = Vector3.UP * jump
	
	if Input.is_action_pressed("move_forward"):
		direction -= transform.basis.z
	elif Input.is_action_pressed("move_backward"):
		direction += transform.basis.z
	if Input.is_action_pressed("move_left"):
		direction -= transform.basis.x
	elif Input.is_action_pressed("move_right"):
		direction += transform.basis.x
		
	direction = direction.normalized()
	h_velocity = h_velocity.linear_interpolate(direction * Global.globalspeed, h_acceleration * delta)
	movement.z = h_velocity.z + gravity_vec.z
	movement.x = h_velocity.x + gravity_vec.x
	movement.y = gravity_vec.y
	
	move_and_slide(movement, Vector3.UP)
		
	


func _on_Area_body_entered(body):
	if body.is_in_group("Player"):
		get_tree().change_scene("res://Start.tscn")
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
