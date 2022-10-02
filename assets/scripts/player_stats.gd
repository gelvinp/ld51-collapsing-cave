extends Node

signal ui_change

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
		Map.TileType.GREEN:
			green += 1
		Map.TileType.YELLOW:
			yellow += 1
		Map.TileType.RED:
			red += 1
	
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
	health -= amount
	emit_signal("ui_change")
	return health > 0


func heal(amount: float):
	health = min(max_health, health + amount)
	emit_signal("ui_change")
