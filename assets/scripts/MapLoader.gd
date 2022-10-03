extends Node


var intro_cleared := false
var room_count := 0

var intro_room = preload("res://assets/Maps/Intro.tscn")
var start_room = preload("res://assets/Maps/Start.tscn")

var small_mine = preload("res://assets/Maps/SmallMine.tscn")

var small_enemy = preload("res://assets/Maps/SmallEnemy.tscn")
var large_enemy = preload("res://assets/Maps/LargeEnemy.tscn")

var upgrade = preload("res://assets/Maps/Upgrade.tscn")

func get_map():
	if not intro_cleared and room_count == 0:
		room_count += 1
		return intro_room.instance()
	elif room_count == 0:
		room_count += 1
		return start_room.instance()
	
	ScoreManager.add_score(100)
	
	if room_count % 20 == 0:
		room_count += 1
		return large_enemy.instance()
	elif room_count % 10 == 0:
		room_count += 1
		return small_enemy.instance()
	elif room_count % 5 == 0:
		room_count += 1
		return upgrade.instance()
	else:
		room_count += 1
		var mine = small_mine.instance()
		
		mine.green_chance = 0.4
		mine.yellow_chance = 0.15 if room_count > 10 else 0.05
		mine.red_chance = 0.05 if room_count > 20 else 0.005
		
		return mine
