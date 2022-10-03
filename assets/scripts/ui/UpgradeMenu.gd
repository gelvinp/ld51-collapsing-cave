extends VBoxContainer

signal completed


export(Array, Resource) var upgrades


var upgrade_1
var upgrade_2
var upgrade_3
var none_avail

var sizing = true

onready var cancel_button := $Button
var audio


# Called when the node enters the scene tree for the first time.
func _ready():
	modulate = Color(1.0, 1.0, 1.0, 0.0)
	
	cancel_button.connect("pressed", self, "_on_cancel_pressed")


func _process(_delta):
	if sizing:
		var drawn_size = rect_size * rect_scale
		var midpoint = drawn_size / 2.0
		var difference = (get_viewport_rect().size / 2.0) - midpoint
		rect_position += difference
		modulate = Color.white
		sizing = false


func _enter_tree():
	var count = upgrades.size()
	upgrade_1 = get_node("VBoxContainer/UpgradeItem")
	upgrade_2 = get_node("VBoxContainer/UpgradeItem2")
	upgrade_3 = get_node("VBoxContainer/UpgradeItem3")
	none_avail = get_node("VBoxContainer/NoneAvail")
	
	if count >= 3:
		upgrade_3.upgrade = upgrades[2]
		upgrade_3.connect("clicked", self, "_on_UpgradeItem_clicked")
	else:
		upgrade_3.free()
	
	if count >= 2:
		upgrade_2.upgrade = upgrades[1]
		upgrade_2.connect("clicked", self, "_on_UpgradeItem_clicked")
	else:
		upgrade_2.queue_free()
	
	if count >= 1:
		upgrade_1.upgrade = upgrades[0]
		upgrade_1.connect("clicked", self, "_on_UpgradeItem_clicked")
		none_avail.queue_free()
	else:
		upgrade_1.queue_free()


func _on_UpgradeItem_clicked(item: Resource):
	if item.apply():
		audio.play()
		emit_signal("completed")


func _on_cancel_pressed():
	emit_signal("completed")
