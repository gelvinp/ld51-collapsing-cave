extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$MapWrangler.connect("start_upgrade", $UI, "open_upgrade")
	$UI.connect("close_upgrade", $MapWrangler, "machine_finish")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
