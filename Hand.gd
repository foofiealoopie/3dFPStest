extends Spatial

const ADS_LERP = 20


export var camera_path : NodePath
var camera: Camera
var fview = {"Default": 70, "ADS": 42}


export var default_position : Vector3
export var ads_position : Vector3

func _ready():
	camera = get_node(camera_path)

func _process(delta):
	if Input.is_action_pressed("fire2") and Global.globalweapon == 3:
		transform.origin = transform.origin.linear_interpolate(ads_position, ADS_LERP * delta)
		camera.fov = lerp(camera.fov, fview["ADS"], ADS_LERP * delta)
		Global.globalspeed = 2
		
	else:
		transform.origin = transform.origin.linear_interpolate(default_position, ADS_LERP * delta)
		camera.fov = lerp(camera.fov, fview["Default"], ADS_LERP * delta)
		Global.globalspeed = 13
