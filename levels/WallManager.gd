extends Node2D
class_name WallManager

@export var espacement: float = 1000;
@export var speed: float = 50;
@onready var rune_sfx = $RuneSFX

@export var character: CharacterBody2D;
@onready var collision_manager = $CollisionManager
@onready var camera_2d = $"../CharacterBody2D/Camera2D"
@onready var score_manager: ScoreManager = $"../ScoreManager"


var actual_espacement: float;

func _ready():
	actual_espacement = espacement;
	
	
func get_rune():
	camera_2d.strength = 2;
	espacement += 125;
	if espacement > 1200: espacement = 1200;
	rune_sfx.play();
	
func _process(delta):
	
	espacement -= delta * speed;
	if espacement < 0 : espacement = 0;
	
	actual_espacement = lerp(actual_espacement, espacement, 0.1);
	speed = 25 + (score_manager.score/2000);
	
	$"ParallaxBackground/ParallaxLayer/Wall Left".position.x = -actual_espacement/2
	$"ParallaxBackground/ParallaxLayer/Wall Right".position.x = actual_espacement/2
	
	pass
