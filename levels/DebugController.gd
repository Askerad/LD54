extends CharacterBody2D

@export var speed: float = 1;

func _process(delta):
	position += Input.get_vector("left", "right","up", "down") * delta * speed;
