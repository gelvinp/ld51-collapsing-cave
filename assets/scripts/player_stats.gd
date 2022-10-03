extends Node

signal ui_change
signal game_over

var stone = 0
var green = 0
var yellow = 0
var red = 0

var stone_placement = false
var movement_speed = 1.0
var mining_speed = 1.0

var max_health = 100.0
var health = 100.0

var attack = 1.0
var defense = 1.0

var upgrades = []


func block_broken(type: int):
	match type:
		Map.TileType.STONE:
			stone += 1
			ScoreManager.add_score(10)
		Map.TileType.GREEN:
			green += 1
			ScoreManager.add_score(20)
		Map.TileType.YELLOW:
			yellow += 1
			ScoreManager.add_score(30)
		Map.TileType.RED:
			red += 1
			ScoreManager.add_score(50)
		Map.TileType.BIG_RED:
			red += 4
			ScoreManager.add_score(500)
	
	emit_signal("ui_change")


func consume_stone(quantity: int) -> bool:
	if stone >= quantity:
		stone -= quantity
		emit_signal("ui_change")
		return true
	
	return false


func consume_green(quantity: int) -> bool:
	if green >= quantity:
		green -= quantity
		emit_signal("ui_change")
		return true
	
	return false


func consume_yellow(quantity: int) -> bool:
	if yellow >= quantity:
		yellow -= quantity
		emit_signal("ui_change")
		return true
	
	return false


func consume_red(quantity: int) -> bool:
	if red >= quantity:
		red -= quantity
		emit_signal("ui_change")
		return true
	
	return false


func take_damage(amount: float) -> bool:
	health -= amount / defense
	emit_signal("ui_change")
	return health > 0


func heal(amount: float):
	health = min(max_health, health + amount)
	emit_signal("ui_change")


func reset():
	stone = 0
	green = 0
	yellow = 0
	red = 0

	stone_placement = false
	movement_speed = 1.0
	mining_speed = 1.0

	max_health = 100.0
	health = 100.0

	attack = 1.0
	defense = 1.0

	upgrades = []
	
