extends Map


func _on_Enemy_died():
	tilemap.set_cell(1, 0, TileType.LADDER)
