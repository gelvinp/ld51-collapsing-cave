extends Node2D

signal game_over


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$MapWrangler.connect("start_upgrade", $UI, "open_upgrade")
	$UI.connect("close_upgrade", $MapWrangler, "machine_finish")
	PlayerStats.connect("game_over", self, "_on_game_over")


func _on_game_over():
	DeathSoundManager.player()
	emit_signal("game_over")
	get_tree().paused = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
