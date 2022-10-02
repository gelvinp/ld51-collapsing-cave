extends Control

signal clicked(upgrade)


export(Resource) var upgrade


onready var button := $Button
onready var name_label := $MarginContainer/VBoxContainer/NameLabel
onready var green_label := $MarginContainer/VBoxContainer/HBoxContainer/HBoxContainer/GreenLabel
onready var yellow_label := $MarginContainer/VBoxContainer/HBoxContainer/HBoxContainer2/YellowLabel
onready var red_label := $MarginContainer/VBoxContainer/HBoxContainer/HBoxContainer3/RedLabel


# Called when the node enters the scene tree for the first time.
func _ready():
	yield(owner, "ready")
	
	if upgrade:
		name_label.text = upgrade.name
		green_label.text = str(upgrade.green_cost)
		yellow_label.text = str(upgrade.yellow_cost)
		red_label.text = str(upgrade.red_cost)
		
		if not upgrade.is_affordable():
			button.disabled = true
			name_label.modulate = Color(0.6, 0.6, 0.6)
			
			if upgrade.green_cost > PlayerStats.green:
				green_label.modulate = Color(0.9, 0.0, 0.1)
			
			if upgrade.yellow_cost > PlayerStats.yellow:
				yellow_label.modulate = Color(0.9, 0.0, 0.1)
			
			if upgrade.red_cost > PlayerStats.red:
				red_label.modulate = Color(0.9, 0.0, 0.1)


func _on_Button_pressed():
	emit_signal("clicked", upgrade)
