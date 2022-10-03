extends KinematicBody2D

signal died

export(float) var gravity = 800.0
export(float) var movement_speed = 800.0
export(float) var distance_squared_threshold = 15000.0
export(float) var health = 50.0
export(float) var attack = 10.0
export(Vector2) var pushback = Vector2(80.0, -100.0)
export(bool) var large = false

onready var left_collision := $LeftCollision
onready var right_collision := $RightCollision
onready var player_area := $Area2D
onready var player_detector := $PlayerDetector

var on_ceiling := true
var _velocity := Vector2.ZERO
var player = null
var _pushback := false

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("squish")


func _physics_process(delta):
	if _pushback:
		_velocity.y += gravity * delta
		_velocity = move_and_slide(_velocity, Vector2.UP)
		_pushback = not is_on_floor()
		return
	elif on_ceiling:
		ceiling_physics(delta)
	else:
		floor_physics(delta)


func ceiling_physics(delta):
	var velocity = Vector2(0.0, -2000.0)
	move_and_slide(velocity, Vector2.UP)


func floor_physics(delta):
	_velocity += Vector2(0.0, gravity) * delta
	
	var player_offset = global_position - player.global_position
	var distance_squared = player_offset.length_squared()
	
	if distance_squared > distance_squared_threshold:
		_velocity.x = 0
	else:
		_velocity.x = sign(-player_offset.x) * movement_speed * delta
	
	if _velocity.x < 0 and not left_collision.is_colliding():
		_velocity.x = 0
	elif _velocity.x > 0 and not right_collision.is_colliding():
		_velocity.x = 0
	
	_velocity = move_and_slide(_velocity, Vector2.UP)
	
	if $AttackArea.overlaps_body(player):
		_on_AttackArea_body_entered(player)
	
	if player_area.monitoring:
		for body in player_area.get_overlapping_bodies():
			print(body.name)
			_on_Area2D_body_entered(body)
		


func _on_Area2D_body_entered(body):
	if not on_ceiling:
		return
		
	if body.get_groups().has("player"):
		player_detector.cast_to = player_detector.to_local(body.global_position)
		player_detector.force_raycast_update()
		
		if player_detector.get_collider() == body:
			player = body
			fall()


func fall():
	player_area.set_deferred("monitoring", false)
	position += Vector2(0.0, 32)
	rotation_degrees = 0
	on_ceiling = false
	left_collision.enabled = true
	right_collision.enabled = true


func _on_AttackArea_body_entered(body):
	var pushback_amount = pushback
	var player_offset = global_position - body.global_position
	pushback_amount.x *= -sign(player_offset.x)
	
	if pushback_amount.x == 0:
		pushback_amount.x = pushback.x

	body.hit(attack, pushback_amount)


func hit(amount: float, pushback: Vector2):
	if $Timer.is_stopped():
		health -= amount
		if health <= 0:
			emit_signal("died")
			ScoreManager.add_score(150 if large else 100)
			if large:
				DeathSoundManager.big()
			else:
				DeathSoundManager.small()
			queue_free()
		else:
			_velocity += pushback
			_pushback = true
			$AudioStreamPlayer.play()
			$Timer.start()
