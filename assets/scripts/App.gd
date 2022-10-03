extends Node2D


onready var main_menu = $MainMenu
onready var credits = $Credits
onready var game_over = $GameOver
onready var score_label = $GameOver/MarginContainer/VBoxContainer/VBoxContainer/ScoreLabel
onready var high_score_label = $GameOver/MarginContainer/VBoxContainer/VBoxContainer/HighScoreLabel
onready var game_scene = preload("res://assets/scenes/Game.tscn")
var active_game


func _on_Button_pressed():
	active_game = game_scene.instance()
	add_child(active_game)
	move_child(active_game, 1)
	main_menu.visible = false
	active_game.connect("game_over", self, "_on_game_over")


func _on_game_over():
	active_game.disconnect("game_over", self, "_on_game_over")
	score_label.text = "Score: " + str(ScoreManager.score)
	high_score_label.text = "High Score: " + str(ScoreManager.high_score)
	game_over.visible = true


func _on_Play_Again_Button_pressed():
	active_game.free()
	MapLoader.room_count = 0
	ScoreManager.score = 0
	PlayerStats.reset()
	active_game = game_scene.instance()
	add_child(active_game)
	move_child(active_game, 1)
	game_over.visible = false
	active_game.connect("game_over", self, "_on_game_over")
	get_tree().paused = false


func _on_Button2_pressed():
	main_menu.visible = false
	credits.visible = true


func _on_Button3_pressed():
	main_menu.visible = true
	credits.visible = false
