extends Node

onready var audio := $AudioStreamPlayer

var await_mining := true


func _process(_delta):
	if await_mining:
		if PlayerStats.green >= 4:
			owner.get_node("TileMap").set_cellv(Vector2(1, -16), Map.TileType.LADDER)
			await_mining = false
			audio.play()


func play():
	audio.play()
