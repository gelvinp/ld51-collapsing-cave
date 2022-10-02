extends Node

var stone = 0
var green = 0
var yellow = 0
var red = 0

var stone_placement = true
var movement_speed = 1.0
var mining_speed = 1.0


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


func consume_stone(quantity: int) -> bool:
	if stone >= quantity:
		stone -= quantity
		return true
	
	return false


func consume_green(quantity: int) -> bool:
	if green >= quantity:
		green -= quantity
		return true
	
	return false


func consume_yellow(quantity: int) -> bool:
	if yellow >= quantity:
		yellow -= quantity
		return true
	
	return false


func consume_red(quantity: int) -> bool:
	if red >= quantity:
		red -= quantity
		return true
	
	return false
