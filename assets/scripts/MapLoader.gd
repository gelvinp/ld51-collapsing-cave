extends Node


var intro_cleared := false
var room_count := 0

var intro_room = preload("res://assets/Maps/Intro.tscn")
var start_room = preload("res://assets/Maps/Start.tscn")

var small_mine = preload("res://assets/Maps/SmallMine.tscn")
var medium_mine = preload("res://assets/Maps/MediumMine.tscn")
var large_mine = preload("res://assets/Maps/LargeMine.tscn")
var sparse_mine = preload("res://assets/Maps/SparseMine.tscn")

var small_enemy = preload("res://assets/Maps/SmallEnemy.tscn")
var large_enemy = preload("res://assets/Maps/LargeEnemy.tscn")

var upgrade = preload("res://assets/Maps/Upgrade.tscn")
var upgrade_challenge = preload("res://assets/Maps/UpgradeChallenge.tscn")

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
		if room_count > 10 and rand_range(0.0, 100.0) < 1.0:
			return upgrade_challenge.instance()
		else:
			return upgrade.instance()
	else:
		if (room_count > 20) and (room_count % 5 < 3):
			var chance = rand_range(0.0, 100.0)
			if chance < 5.0:
				room_count += 3
				var mine = large_mine.instance()
				mine.green_chance = 0.45
				mine.yellow_chance = 0.2
				mine.red_chance = 0.08
				mine.stone_removal_chance = 0.1
				return mine
			elif chance < 7.0:
				room_count += 1
				var mine = sparse_mine.instance()
				mine.green_chance = 0.8
				mine.yellow_chance = 0.6
				mine.red_chance = 0.4
				mine.stone_removal_chance = 0
				return mine
		
		if room_count % 5 < 4 and rand_range(0.0, 100.0) < 40.0:
			room_count += 2
			var mine = medium_mine.instance()
			mine.green_chance = 0.4
			mine.yellow_chance = 0.15 if room_count > 10 else 0.05
			mine.red_chance = 0.05 if room_count > 20 else 0.005
			mine.stone_removal_chance = 0.18
			return mine
		
		room_count += 1
		var mine = small_mine.instance()
		
		mine.green_chance = 0.4
		mine.yellow_chance = 0.15 if room_count > 10 else 0.05
		mine.red_chance = 0.05 if room_count > 20 else 0.005
		mine.stone_removal_chance = 0.08
		
		return mine
