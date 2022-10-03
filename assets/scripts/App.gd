extends Node2D


onready var main_menu = $MainMenu
onready var game_over = $GameOver
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
	game_over.visible = true


func _on_Play_Again_Button_pressed():
	active_game.free()
	MapLoader.room_count = 0
	active_game = game_scene.instance()
	add_child(active_game)
	move_child(active_game, 1)
	game_over.visible = false
	active_game.connect("game_over", self, "_on_game_over")
	get_tree().paused = false
