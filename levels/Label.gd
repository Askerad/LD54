extends Label

@export var scoreManager: ScoreManager;

func _process(delta):
	text = str(scoreManager.score);
