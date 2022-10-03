extends Node


var enemy_small: AudioStreamPlayer
var enemy_big: AudioStreamPlayer
var player: AudioStreamPlayer
var big_red: AudioStreamPlayer

var enemy_small_sound = preload("res://assets/sounds/death_small.wav")
var enemy_big_sound = preload("res://assets/sounds/death_large.wav")
var player_sound = preload("res://assets/sounds/game_over.wav")
var big_red_sound = preload("res://assets/sounds/big_red.wav")

# Called when the node enters the scene tree for the first time.
func _ready():
	enemy_small = AudioStreamPlayer.new()
	enemy_small.stream = enemy_small_sound
	add_child(enemy_small)
	enemy_big = AudioStreamPlayer.new()
	enemy_big.stream = enemy_big_sound
	add_child(enemy_big)
	player = AudioStreamPlayer.new()
	player.stream = player_sound
	add_child(player)
	big_red = AudioStreamPlayer.new()
	big_red.stream = big_red_sound
	add_child(big_red)
	
	pause_mode = Node.PAUSE_MODE_PROCESS


func small():
	enemy_small.play()


func big():
	enemy_big.play()


func player():
	player.play()


func red():
	big_red.play()
