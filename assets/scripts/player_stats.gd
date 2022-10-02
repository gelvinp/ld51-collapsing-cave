extends Node

var stone = 0
var green = 0
var yellow = 0
var red = 0

var stone_upgrade = false
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
