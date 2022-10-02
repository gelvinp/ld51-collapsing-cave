extends Node

onready var upgrades = [
	preload("res://assets/resources/Upgrades/stone_placement.tres"),
	preload("res://assets/resources/Upgrades/movement_1.tres"),
	preload("res://assets/resources/Upgrades/movement_2.tres"),
	preload("res://assets/resources/Upgrades/movement_3.tres"),
	preload("res://assets/resources/Upgrades/mining_1.tres"),
	preload("res://assets/resources/Upgrades/mining_2.tres"),
	preload("res://assets/resources/Upgrades/mining_3.tres"),
	preload("res://assets/resources/Upgrades/heal.tres"),
	preload("res://assets/resources/Upgrades/max_health_1.tres"),
	preload("res://assets/resources/Upgrades/max_health_2.tres"),
	preload("res://assets/resources/Upgrades/max_health_3.tres"),
	preload("res://assets/resources/Upgrades/attack_1.tres"),
	preload("res://assets/resources/Upgrades/attack_2.tres"),
	preload("res://assets/resources/Upgrades/attack_3.tres"),
	preload("res://assets/resources/Upgrades/defense_1.tres"),
	preload("res://assets/resources/Upgrades/defense_2.tres"),
	preload("res://assets/resources/Upgrades/defense_3.tres"),
]


func get_visible_upgrades() -> Array:
	var visible = []
	
	for upgrade in upgrades:
		if upgrade.is_visible():
			visible.append(upgrade)
	
	while visible.size() > 3:
		visible.remove(randi() % visible.size())
	
	return visible
