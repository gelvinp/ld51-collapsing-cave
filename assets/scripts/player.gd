extends KinematicBody2D

signal attempt_mine(offset)

enum Facing { LEFT = -1, RIGHT = 1 }

export(float) var max_speed_x = 400.0
export(float) var max_speed_y = 500.0
export(float) var gravity_accel = 1000.0
export(float) var jump_strength = 400.0
export(float) var min_y = 80.0
export(float) var climb_speed = 300.0

onready var audio_jump := $AudioJump
onready var audio_land := $AudioLand
onready var audio_hit := $AudioHit

var is_on_ladder := false
var _velocity := Vector2.ZERO
var _facing = Facing.LEFT
var _last_mine := Vector2.ZERO
var _in_air := false


func _process(_delta):
	var intended_mine = Input.get_vector("mine_left", "mine_right", "mine_up", "mine_down").normalized() * 32
	
	if _last_mine != intended_mine:
		_last_mine = intended_mine
		emit_signal("attempt_mine", intended_mine)
			


func _physics_process(delta):
	_velocity.x = Input.get_axis("move_left", "move_right") * max_speed_x * PlayerStats.movement_speed
	_facing = sign(_velocity.x)
	
	
	if is_on_ladder:
		_velocity.y = Input.get_action_strength("jump") * -climb_speed * PlayerStats.movement_speed
	else:
		_velocity.y += gravity_accel * delta
		
		if Input.is_action_just_pressed("jump") and is_on_floor():
			audio_jump.play()
			_velocity.y = -jump_strength
	
	_velocity.y = clamp(_velocity.y, -max_speed_y, jump_strength)
		
	_velocity = move_and_slide(_velocity, Vector2.UP)
	
	if not is_on_floor():
		_in_air = true
	elif _in_air:
		_in_air = false
		#audio_land.play()
	
	if position.y > 256:
		print("Die")
