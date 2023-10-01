extends Area2D

@export var camera: Camera2D;

func _process(delta):
	position.y = camera.get_screen_center_position().y - 360 + 720 
	
	print(position.y)
