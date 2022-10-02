extends Node2D

const MAP_MOVER := preload("res://assets/scripts/map_mover.gd")
const TILE_HEIGHT := 32
const INVALID_TILE := Vector2(-1, -1)
const TODO_INTRO := preload("res://assets/Maps/Intro.tscn")

export(int, 1, 4) var tiles_to_move = 1

onready var shift_down_timer: Timer = $ShiftDownTimer
onready var player = $Player
onready var _incoming_map: Map = $IntroMap
onready var _map_mover: MapMover = $MapMover
onready var _block_breaker: BlockBreaker = $BlockBreaker

var _outgoing_map: Map = null
var _mine_offset := Vector2.ZERO
var _mine_tile := INVALID_TILE
var _mine_type = -1
var _mine_position := Vector2.ZERO

func _ready():
	randomize()
	shift_down_timer.start()
	player.connect("slide_world", self, "_on_player_slide_world")
	_map_mover.connect("timeout", self, "_on_MapMover_timeout")
	_map_mover.maps = [_incoming_map, player, _block_breaker]
	player.connect("attempt_mine", self, "_on_player_attempt_mine")
	_block_breaker.connect("block_broken", self, "_on_block_breaker_block_broken")


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
	
	if _mine_offset.length_squared() != 0:
		var intended_block = mining_intended_block()
		
		if !intended_block.is_equal_approx(_mine_tile):
			_mine_tile = intended_block
			
			match _mine_type:
				Map.TileType.STONE:
					_block_breaker.start(_mine_position, 2.5)
				Map.TileType.GREEN:
					_block_breaker.start(_mine_position, 5)
				Map.TileType.YELLOW:
					_block_breaker.start(_mine_position, 7.5)
				Map.TileType.RED:
					_block_breaker.start(_mine_position, 10)
				_:
					_block_breaker.stop()
	elif !_mine_tile.is_equal_approx(INVALID_TILE):
		_mine_tile = INVALID_TILE
		_block_breaker.stop()


func mining_intended_block() -> Vector2:
	var mine_block = player.global_position + Vector2(0, -16) + _mine_offset
	
	if _incoming_map:
		var incoming_position = _incoming_map.global_to_map(mine_block)
		_mine_type = _incoming_map.tilemap.get_cellv(incoming_position)
		if _mine_type != -1:
			_mine_position = _incoming_map.map_to_global(incoming_position)
			return incoming_position
	
	if _outgoing_map:
		var outgoing_position = _outgoing_map.global_to_map(mine_block)
		_mine_type = _outgoing_map.tilemap.get_cellv(outgoing_position)
		if _mine_type != -1:
			_mine_position = _outgoing_map.map_to_global(outgoing_position)
			return outgoing_position
	
	_mine_type = -1
	return INVALID_TILE


func _on_ShiftDownTimer_timeout():
	_map_mover.start(1.0, tiles_to_move * TILE_HEIGHT)


func _on_MapMover_timeout():
	shift_down_timer.start()


func _on_player_slide_world(amount: float):
	if _incoming_map:
		_incoming_map.position += Vector2(0.0, amount)
	if _outgoing_map:
		_outgoing_map.position += Vector2(0.0, amount)
		
	_block_breaker.position += Vector2(0.0, amount)
	
	player.position += Vector2(0.0, amount)
	

func _on_player_attempt_mine(position: Vector2):
	_mine_offset = position


func _on_block_breaker_block_broken():
	if _incoming_map:
		var incoming_position = _incoming_map.global_to_map(_mine_position)
		if _mine_type == _incoming_map.tilemap.get_cellv(incoming_position):
			_incoming_map.tilemap.set_cellv(incoming_position, -1)
			return
	
	if _outgoing_map:
		var outgoing_position = _outgoing_map.global_to_map(_mine_position)
		if _mine_type == _outgoing_map.tilemap.get_cellv(outgoing_position):
			_incoming_map.tilemap.set_cellv(outgoing_position, -1)
			return
