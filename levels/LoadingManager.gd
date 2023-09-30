extends Node2D

@export var loaded_levels_count: int = 10;

var parts : Array[PackedScene] = [
	preload("res://levels/parts/part1.tscn"),
#	preload("res://levels/parts/part2.tscn"),
	# preload("res://levels/parts/part3.tscn"),
#	preload("res://levels/parts/part4.tscn"),
];
var rng = RandomNumberGenerator.new();

var currently_loaded_parts: Array[Part];

func _ready():
	for i in range(0, int(loaded_levels_count/2)):
		load_next_level()
		
	
func handle_level_loading(): 
	clean_used_levels();
	load_next_level();
	print(currently_loaded_parts.size());
	print(get_child_count());
	
	
	
func clean_used_levels():
	var range = range(0, currently_loaded_parts.size());
	range.reverse()
	for part_index in range:
		if part_index >= loaded_levels_count:
			var part = currently_loaded_parts[part_index];
			currently_loaded_parts.remove_at(part_index);
			part.queue_free();
		
	
func load_next_level():
	var last_part = currently_loaded_parts[0] if currently_loaded_parts.size() else parts[0].instantiate();
	var part_prefab: PackedScene = pick_random_level_part();
	var part : Part = part_prefab.instantiate();
	
	part.position.y = last_part.position.y - last_part.height * 32
	
	currently_loaded_parts.push_front(part);
	add_child(part);
	
	part.connect("loading_zone_entered", handle_level_loading);
		


func pick_random_level_part():
	var index = rng.randi_range(0, parts.size() - 1);
	return parts[index];
