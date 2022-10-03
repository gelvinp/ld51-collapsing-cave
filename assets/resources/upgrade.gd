extends Resource

export(String) var name

export(int) var green_cost
export(int) var yellow_cost
export(int) var red_cost

export(Array, Resource) var prerequisites

export(bool) var set_build
export(float) var set_movement_speed
export(float) var set_mining_speed
export(float) var add_health
export(float) var add_max_health
export(float) var set_attack
export(float) var set_defense

export(float) var score


func _init(_name = "", _green = 0, _yellow = 0, _red = 0, _prereq = [], _build = false, _movement = 0.0, _mining = 0.0, _health = 0.0, _max_health = 0.0, _attack = 0.0, _defense = 0.0):
	name = _name
	green_cost = _green
	yellow_cost = _yellow
	red_cost = _red
	prerequisites = _prereq
	set_build = _build
	set_movement_speed = _movement
	set_mining_speed = _mining
	add_health = _health
	add_max_health = _max_health
	set_attack = _attack
	set_defense = _defense


func is_visible() -> bool:
	for prereq in prerequisites:
		if not PlayerStats.upgrades.has(prereq):
			return false
	
	if add_health > 0:
		return true
	
	return not PlayerStats.upgrades.has(self)


func is_affordable() -> bool:
	return green_cost <= PlayerStats.green and yellow_cost <= PlayerStats.yellow and red_cost <= PlayerStats.red


func apply() -> bool:
	if not is_visible():
		return false
	if not is_affordable():
		return false
	if not (PlayerStats.consume_green(green_cost) and PlayerStats.consume_yellow(yellow_cost) and PlayerStats.consume_red(red_cost)):
		return false
	
	if set_build:
		PlayerStats.stone_placement = true
	
	if set_movement_speed > 0:
		PlayerStats.movement_speed = set_movement_speed
	
	if set_mining_speed > 0:
		PlayerStats.mining_speed = set_mining_speed
	
	if add_health > 0:
		PlayerStats.heal(add_health)
	
	if add_max_health > 0:
		PlayerStats.max_health += add_max_health
		PlayerStats.heal(PlayerStats.max_health)
	
	if set_attack > 0:
		PlayerStats.attack = set_attack
	
	if set_defense > 0:
		PlayerStats.defense = set_defense
	
	PlayerStats.upgrades.append(self)
	ScoreManager.add_score(score)
	
	return true
