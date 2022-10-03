extends KinematicBody2D

signal attempt_mine(offset)

enum Facing { LEFT = -1, RIGHT = 1 }

export(float) var max_speed_x = 400.0
export(float) var max_speed_y = 500.0
export(float) var gravity_accel = 1000.0
export(float) var jump_strength = 400.0
export(float) var min_y = 80.0
export(float) var climb_speed = 300.0
export(float) var attack_amount = 20.0

onready var audio_jump := $AudioJump
onready var audio_land := $AudioLand
onready var audio_hit := $AudioHit
onready var audio_attack := $AudioAttack
onready var attack_scene := preload("res://assets/scenes/attack.tscn")

var is_on_ladder := false
var _velocity := Vector2.ZERO
var _facing = Facing.LEFT
var _last_mine := Vector2.ZERO
var _in_air := false
var _pushback := false
var _attack_ready := true


func _process(_delta):
	var intended_mine = Input.get_vector("mine_left", "mine_right", "mine_up", "mine_down") * 32
	
	if _last_mine != intended_mine:
		_last_mine = intended_mine
		emit_signal("attempt_mine", intended_mine)
	
	if Input.is_action_just_pressed("attack") and _attack_ready:
		attack()


func _physics_process(delta):
	if _pushback:
		_velocity.y += gravity_accel * delta
		_velocity.y = clamp(_velocity.y, -max_speed_y, jump_strength)
		_velocity = move_and_slide(_velocity, Vector2.UP)
		_pushback = not is_on_floor()
		return
	
	_velocity.x = Input.get_axis("move_left", "move_right") * max_speed_x * PlayerStats.movement_speed
	if _velocity.x < 0:
		_facing = Facing.LEFT
	elif _velocity.x > 0:
		_facing = Facing.RIGHT
	
	
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
		PlayerStats.emit_signal("game_over")


func hit(amount: float, pushback: Vector2):
	if $IFrames.is_stopped():
		if not PlayerStats.take_damage(amount):
			print("Died!")
			PlayerStats.emit_signal("game_over")
			DeathSoundManager.player()
		else:
			_velocity += pushback
			_pushback = true
			audio_hit.play()
			$IFrames.start()


func attack():
	_attack_ready = false
	$Timer.start()
	var attack_position = global_position + Vector2(32 * (1 if _facing == Facing.RIGHT else -1), -16)
	var attack = attack_scene.instance()
	attack.damage = attack_amount * PlayerStats.attack
	attack.player = self
	attack.global_position = attack_position
	owner.add_child(attack)
	audio_attack.play()


func _on_Timer_timeout():
	_attack_ready = true
