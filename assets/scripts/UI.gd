extends Control

signal close_upgrade


onready var stone := $VBoxContainer/HBoxContainer4/StoneLabel
onready var green := $VBoxContainer/HBoxContainer/GreenLabel
onready var yellow := $VBoxContainer/HBoxContainer2/YellowLabel
onready var red := $VBoxContainer/HBoxContainer3/RedLabel
onready var upgrade_menu := preload("res://assets/scenes/ui/UpgradeMenu.tscn")
onready var background := $ColorRect
onready var upgrade_audio := $UpgradeAudio

var _menu = null


# Called when the node enters the scene tree for the first time.
func _ready():
	PlayerStats.connect("ui_change", self, "update_ui")


func update_ui():
	stone.text = str(PlayerStats.stone)
	green.text = str(PlayerStats.green)
	yellow.text = str(PlayerStats.yellow)
	red.text = str(PlayerStats.red)


func open_upgrade():
	background.visible = true
	_menu = upgrade_menu.instance()
	_menu.upgrades = UpgradeProvider.get_visible_upgrades()
	_menu.audio = upgrade_audio
	add_child(_menu)
	_menu.connect("completed", self, "close_upgrade")


func close_upgrade():
	background.visible = false
	_menu.disconnect("completed", self, "close_upgrade")
	_menu.queue_free()
	get_tree().paused = false
	emit_signal("close_upgrade")
