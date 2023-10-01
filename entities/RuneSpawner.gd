extends Node2D
class_name RuneSpawner
@export var probability : float;
var rng = RandomNumberGenerator.new();
var rune = preload("res://entities/Rune.tscn")

func _ready():
	if probability > rng.randf_range(0.0, 1.0):
		add_child(rune.instantiate())


