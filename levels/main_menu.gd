extends Node2D

@onready var label_time = $Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	label_time.start()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print(label_time.time_left)
	if label_time.timeout:
		if !$title.visible:
			$title.visible = true
		else:
			$title.visible = false
