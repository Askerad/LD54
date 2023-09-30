extends Node2D

@export var espacement: float = 1000;
@export var speed: float = 50;

func _process(delta):
	
	espacement -= delta * speed;
	
	if espacement < 0 : espacement = 0;
	
	$"Wall Left".position.x = -espacement/2
	$"Wall Right".position.x = espacement/2
	
	pass
