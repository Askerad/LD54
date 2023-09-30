extends Camera2D

@export var target: Node2D;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	position.y = lerp(position.y ,target.position.y, 0.1) 
	
	pass
