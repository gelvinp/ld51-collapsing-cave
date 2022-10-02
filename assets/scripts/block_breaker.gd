class_name BlockBreaker
extends Node2D

signal block_broken

onready var rect := $Node2D/ColorRect

var _break_time := 0.0
var _elapsed_time := 0.0

func _ready():
	visible = false
	set_process(false)

func start(block_position: Vector2, break_time: float):
	_break_time = break_time
	_elapsed_time = 0.0
	position = block_position
	set_process(true)
	visible = true


func stop():
	_break_time = 0.0
	_elapsed_time = 0.0
	rect.rect_size.y = 0
	set_process(false)
	visible = false


func _process(delta):
	_elapsed_time += delta
	var progress = _elapsed_time / _break_time
	
	rect.rect_size.y = progress * 32.0
	
	if _elapsed_time >= _break_time:
		emit_signal("block_broken")
		stop()
