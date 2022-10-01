class_name MapMover
extends Node

signal timeout

var maps := []

var _movement_time := 1.0
var _elapsed_time := 0.0
var _distance_to_move := 0.0
var _last_position := 0.0


func _ready():
	self.set_process(false)


func start(movement_time: float, distance_to_move: float) -> void:
	_movement_time = movement_time
	_distance_to_move = distance_to_move
	self.set_process(true)
	_elapsed_time = 0.0
	_last_position = 0.0


func _process(delta) -> void:
	_elapsed_time += delta
	
	if _elapsed_time > _movement_time:
		emit_signal("timeout")
		self.set_process(false)
	
	# https://easings.net/#easeInOutQuart
	var prog = _elapsed_time / _movement_time
	var eased = (8 * pow(prog, 4.0) if prog < 0.5 else 1.0 - (pow(-2.0 * prog + 2.0, 4.0) / 2.0)) * _distance_to_move
	
	var needed = eased - _last_position
	_last_position = eased
	
	for map in maps:
		if map:
			map.position += Vector2(0.0, needed)
