extends Node2D

const MAP_MOVER := preload("res://assets/scripts/map_mover.gd")
const TILE_HEIGHT := 32
const TODO_INTRO := preload("res://assets/Maps/Intro.tscn")

export(int, 1, 4) var tiles_to_move = 1

onready var shift_down_timer: Timer = $ShiftDownTimer
onready var player = $Player
onready var _incoming_map: Map = $IntroMap
onready var _map_mover: MapMover = $MapMover
onready var _block_breaker: BlockBreaker = $BlockBreaker

var _outgoing_map: Map = null

func _ready():
	randomize()
	shift_down_timer.start()
	player.connect("slide_world", self, "_on_player_slide_world")
	_map_mover.connect("timeout", self, "_on_MapMover_timeout")
	_map_mover.maps = [_incoming_map, player, _block_breaker]


func _process(_delta):
	if _outgoing_map and _outgoing_map.top_node.global_position.y > 256:
		_map_mover.maps.erase(_outgoing_map)
		_outgoing_map.queue_free()
		_outgoing_map = null
	
	if _incoming_map and _incoming_map.top_node.global_position.y >= 0:
		if _outgoing_map:
			printerr("Outgoing map still exists at switchover!")
		
		_outgoing_map = _incoming_map
		# TODO: Load an actually new map
		_incoming_map = TODO_INTRO.instance()
		add_child(_incoming_map)
		_incoming_map.position.y = -256 + _outgoing_map.top_node.global_position.y
		_map_mover.maps.append(_incoming_map)


func _on_ShiftDownTimer_timeout():
	_map_mover.start(1.0, tiles_to_move * TILE_HEIGHT)


func _on_MapMover_timeout():
	shift_down_timer.start()


func _on_player_slide_world(amount: float):
	if _incoming_map:
		_incoming_map.position += Vector2(0.0, amount)
	if _outgoing_map:
		_outgoing_map.position += Vector2(0.0, amount)
	
	player.position += Vector2(0.0, amount)
	
