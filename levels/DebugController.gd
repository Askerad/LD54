extends CharacterBody2D

@export var speed: float = 1;

func _process(delta):
	velocity = Input.get_vector("left", "right","up", "down") * speed;
	move_and_slide();
