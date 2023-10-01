extends Label

@export var target: Node2D;

func _process(delta):
	text = str(target.find_child("CoyoteTimer").time_left);
	
	pass
