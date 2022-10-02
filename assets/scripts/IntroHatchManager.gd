extends Node

var await_mining := true


func _process(_delta):
	if await_mining:
		if PlayerStats.green >= 4:
			owner.get_node("TileMap").set_cellv(Vector2(0, 0), Map.TileType.LADDER)
			await_mining = false
	else:
		set_process(false)
