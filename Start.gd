extends Control


func _ready():
	pass


func _on_Button_pressed():
	get_tree().change_scene("MainWorld.tscn")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
