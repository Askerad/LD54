extends Label

@export var target: Node2D;

func _process(delta):
	match target.state:
		0: text = "Running"
		1: text = "Jumping"
		2: text = "Falling"
		3: text = "Walljumping"
		4: text = "Dashing"
	pass
