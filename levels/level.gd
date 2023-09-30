extends Node2D

@onready var game_over_screen = $CharacterBody2D/Camera2D/UiCanvas/GameOverScreen
@onready var fondnoir = $CharacterBody2D/Camera2D/UiCanvas/Fondnoir



func _on_restart_button_pressed():
	get_tree().reload_current_scene()


func _on_played_died():
	fondnoir.visible = true;
	game_over_screen.visible = true;
	
