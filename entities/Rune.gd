extends Node2D
class_name Rune

@export var effect_size: float;

var pos_cache: Vector2;
var time: float;

func _ready():
	pos_cache = position;
	time = 0;

func _process(delta):
	time += delta;
	position.y = pos_cache.y + sin(time*3) * 2.5;

func _on_rune_body_entered(body):
	
	if body is CharacterBody2D:
		print("Rune Consumed")
		self.queue_free()
		var wallManager : Node2D = get_parent().get_parent().get_parent().find_child("WallManager");
		wallManager.espacement += effect_size;
	
	
	pass # Replace with function body.
