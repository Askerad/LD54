extends Node2D


@export var espacement: float = 1000;
@export var speed: float = 50;

func _process(delta):
	
	espacement -= delta * speed;
	
	if espacement < 0 : espacement = 0;
	
	$"ParallaxBackground/ParallaxLayer/Wall Left".position.x = -espacement/2
	$"ParallaxBackground/ParallaxLayer/Wall Right".position.x = espacement/2
	
	pass
