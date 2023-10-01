extends Node2D

@onready var game_over_screen = $CharacterBody2D/Camera2D/UiCanvas/GameOverScreen
@onready var fondnoir = $CharacterBody2D/Camera2D/UiCanvas/Fondnoir

@onready var falling_sfx = $FallingSFX
@onready var music = $AudioStreamPlayer
@onready var game_over_drone = $GameOverDrone


func _on_restart_button_pressed():
	get_tree().reload_current_scene()


func _on_played_died():
	fondnoir.visible = true;
	game_over_screen.visible = true;
	music.stop()
	game_over_drone.play()
	
func _on_kill_box_body_entered(body):
	if body is CharacterBody2D:
		falling_sfx.play()
		_on_played_died()
