extends Node2D

var player: CharacterBody2D;
@onready var left_wall = $LeftWall
@onready var right_wall = $RightWall

func _ready():
	player = get_parent().character;

func _process(delta):
	print(player.position)
	position.y = player.position.y
	left_wall.position.x = -get_parent().actual_espacement/2
	right_wall.position.x = get_parent().actual_espacement/2
