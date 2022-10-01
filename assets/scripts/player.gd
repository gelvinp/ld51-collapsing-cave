extends KinematicBody2D

signal slide_world(amount)

enum Facing { LEFT = -1, RIGHT = 1 }

export(float) var max_speed_x = 400.0
export(float) var max_speed_y = 500.0
export(float) var gravity_accel = 1000.0
export(float) var jump_strength = 400.0
export(float) var min_y = 80.0

var _velocity := Vector2.ZERO
var _facing = Facing.LEFT


func _physics_process(delta):
	_velocity.x = Input.get_axis("move_left", "move_right") * max_speed_x
	_facing = sign(_velocity.x)
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		_velocity.y = -jump_strength
	
	_velocity += Vector2(0.0, gravity_accel * delta)
	_velocity.y = clamp(_velocity.y, -max_speed_y, jump_strength)
		
	_velocity = move_and_slide(_velocity, Vector2.UP)
	
	var y_offset = min_y - position.y
	if y_offset > 0:
		position.y += y_offset
		emit_signal("slide_world", y_offset)
	
	if position.y > 256:
		print("Die")
