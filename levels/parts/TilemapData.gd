extends TileMap
class_name Part

signal loading_zone_entered

@export var height: int;

func _ready():
	calculate_bounds();

func calculate_bounds():
	var used_cells = self.get_used_cells(0)
	for pos in used_cells:
		if abs(pos.y) > height:
			height = int(abs(pos.y))


func _on_loading_zone_body_entered(body):
	if body is CharacterBody2D: 
		emit_signal("loading_zone_entered")
		$LoadingZone.queue_free()
	pass # Replace with function body.
