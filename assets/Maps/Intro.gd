extends Map


func _on_Enemy_died():
	tilemap.set_cellv(Vector2(9, -38), Map.TileType.LADDER)
	$HatchManager.play()
