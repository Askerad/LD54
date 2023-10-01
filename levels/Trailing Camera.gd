extends Camera2D

var time : float = 0;
var rng = RandomNumberGenerator.new();
var strength: float = 1;

func _process(delta):
	strength = lerp(strength, 0.0, 0.1)
	offset.y = rng.randf_range(-5, 5) * strength;
	offset.x = rng.randf_range(-5, 5) * strength;
