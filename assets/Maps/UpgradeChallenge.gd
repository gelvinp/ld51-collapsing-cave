extends Map


var enemies_remaining = 3



func _on_Enemy_died():
	enemies_remaining -= 1
	
	if enemies_remaining == 0:
		$TileMap.set_cell(1, -6, TileType.LADDER)
		$AudioStreamPlayer.play()
