extends Node

class_name ScoreManager

@export var score: int = 0;
@export var max_height_reached: int = -100;
@export var player: CharacterBody2D;

func _process(delta):
	if(player.position.y < max_height_reached):
		max_height_reached = player.position.y
		score = -player.position.y;

