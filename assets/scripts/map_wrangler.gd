class_name MapWrangler
extends Node2D

signal start_upgrade

const MAP_MOVER := preload("res://assets/scripts/map_mover.gd")
const TILE_HEIGHT := 32
const INVALID_TILE := Vector2(-1, -1)

export(int, 1, 4) var tiles_to_move = 1

onready var shift_down_timer: Timer = $ShiftDownTimer
onready var player = $Player
onready var _map_mover: MapMover = $MapMover
onready var _block_breaker: BlockBreaker = $BlockBreaker
onready var _audio_build := $AudioBuild
onready var _audio_mine := $AudioMine
onready var _audio_shift := $AudioShift

var _incoming_map: Map = null
var _outgoing_map: Map = null
var _mine_offset := Vector2.ZERO
var _mine_tile := INVALID_TILE
var _mine_type = -1
var _mine_position := Vector2.ZERO
var _mining_map
var _upgrade_open := false

func _ready():
	randomize()
	_incoming_map = MapLoader.get_map()
	add_child(_incoming_map)
	move_child(_incoming_map, 0)
	
	shift_down_timer.start()
	_map_mover.connect("timeout", self, "_on_MapMover_timeout")
	_map_mover.maps = [_incoming_map, player, _block_breaker]
	player.connect("attempt_mine", self, "_on_player_attempt_mine")
	_block_breaker.connect("block_broken", self, "_on_block_breaker_block_broken")


func _process(_delta):
	if _outgoing_map and _outgoing_map.top_node.global_position.y > 256:
		if _outgoing_map.name == "IntroMap":
			MapLoader.intro_cleared = true
		
		_map_mover.maps.erase(_outgoing_map)
		_outgoing_map.queue_free()
		_outgoing_map = null
	
	if _incoming_map and _incoming_map.top_node.global_position.y >= 0:
		if _outgoing_map:
			printerr("Outgoing map still exists at switchover!")
		
		_outgoing_map = _incoming_map
		# TODO: Load an actually new map
		_incoming_map = MapLoader.get_map()
		add_child(_incoming_map)
		move_child(_incoming_map, 0)
		_incoming_map.position.y = -256 + _outgoing_map.top_node.global_position.y
		_map_mover.maps.append(_incoming_map)
	
	if _mine_offset.length_squared() != 0:
		var intended_block = mining_intended_block()
		
		if !intended_block.is_equal_approx(_mine_tile):
			_mine_tile = intended_block
			
			match _mine_type:
				Map.TileType.STONE:
					_block_breaker.start(_mine_position, 2.5 / PlayerStats.mining_speed)
				Map.TileType.GREEN:
					_block_breaker.start(_mine_position, 5 / PlayerStats.mining_speed)
				Map.TileType.YELLOW:
					_block_breaker.start(_mine_position, 7.5 / PlayerStats.mining_speed)
				Map.TileType.RED:
					_block_breaker.start(_mine_position, 10 / PlayerStats.mining_speed)
				_:
					_block_breaker.stop()
	elif !_mine_tile.is_equal_approx(INVALID_TILE):
		_mine_tile = INVALID_TILE
		_block_breaker.stop()
	
	if Input.is_action_just_pressed("build") and PlayerStats.stone_placement:
		build()


func _physics_process(_delta):
	handle_ladder()
	
	var y_offset = player.min_y - player.global_position.y
	if y_offset > 0:
		player.position.y += y_offset
		
		if _incoming_map:
			_incoming_map.position += Vector2(0.0, y_offset)
		if _outgoing_map:
			_outgoing_map.position += Vector2(0.0, y_offset)
			
		_block_breaker.position += Vector2(0.0, y_offset)
		_mine_position += Vector2(0.0, y_offset)


func handle_ladder():
	var ladder_search_position = player.global_position - Vector2(0, 1)
	
	if _incoming_map:
		var incoming_position = _incoming_map.global_to_map(ladder_search_position)
		var type = _incoming_map.tilemap.get_cellv(incoming_position)
		if type != -1:
			player.is_on_ladder = type == Map.TileType.LADDER
			return
	
	if _outgoing_map:
		var outgoing_position = _outgoing_map.global_to_map(ladder_search_position)
		var type = _outgoing_map.tilemap.get_cellv(outgoing_position)
		if type != -1:
			player.is_on_ladder = type == Map.TileType.LADDER
			return
	
	player.is_on_ladder = false


func mining_intended_block() -> Vector2:
	var mine_block = player.global_position + Vector2(0, -16) + _mine_offset
	
	if _incoming_map:
		var incoming_position = _incoming_map.global_to_map(mine_block)
		_mine_type = _incoming_map.tilemap.get_cellv(incoming_position)
		if _mine_type != -1:
			if _mine_type == Map.TileType.MACHINE:
				_incoming_map.tilemap.set_cellv(incoming_position, Map.TileType.MACHINE_SPENT)
				machine()
				return incoming_position
		
			_mine_position = _incoming_map.map_to_global(incoming_position)
			_mining_map = _incoming_map
			return incoming_position
	
	if _outgoing_map:
		var outgoing_position = _outgoing_map.global_to_map(mine_block)
		_mine_type = _outgoing_map.tilemap.get_cellv(outgoing_position)
		if _mine_type != -1:
			if _mine_type == Map.TileType.MACHINE:
				_outgoing_map.tilemap.set_cellv(outgoing_position, Map.TileType.MACHINE_SPENT)
				machine()
				return outgoing_position
			
			_mine_position = _outgoing_map.map_to_global(outgoing_position)
			_mining_map = _outgoing_map
			return outgoing_position
	
	_mine_type = -1
	return INVALID_TILE


func machine():
	if _upgrade_open:
		return
	
	_upgrade_open = true
	
	emit_signal("start_upgrade")
	
	get_tree().paused = true


func machine_finish():
	_upgrade_open = false


func build():
	var offset = 16
	var last_acceptable = null
	var acceptable_map = null
	
	while offset < 16+32*4:
		var target_block = player.global_position + Vector2(0, offset)
		
		if _incoming_map:
			var incoming_position = _incoming_map.global_to_map(target_block)
			if _incoming_map.tilemap.get_cellv(incoming_position) == -1:
				if _incoming_map.tilemap.get_cellv(incoming_position + Vector2(0, 1)) != -1:
					last_acceptable = incoming_position
					acceptable_map = _incoming_map
					break
			else:
				break
		
		if _outgoing_map:
			var outgoing_position = _outgoing_map.global_to_map(target_block)
			if _outgoing_map.tilemap.get_cellv(outgoing_position) == -1:
				if _outgoing_map.tilemap.get_cellv(outgoing_position + Vector2(0, 1)) != -1:
					last_acceptable = outgoing_position
					acceptable_map = _outgoing_map
					break
			else: break
		
		offset += 32
	
	if last_acceptable and PlayerStats.consume_stone(1):
		acceptable_map.tilemap.set_cellv(last_acceptable, Map.TileType.STONE)
		_audio_build.play()


func _on_ShiftDownTimer_timeout():
	_map_mover.start(1.0, tiles_to_move * TILE_HEIGHT)
	_audio_shift.play()


func _on_MapMover_timeout():
	shift_down_timer.start()
	

func _on_player_attempt_mine(position: Vector2):
	_mine_offset = position


func _on_block_breaker_block_broken():
	PlayerStats.block_broken(_mine_type)
	_audio_mine.play()
	_mining_map.tilemap.set_cellv(_mine_tile, -1)
