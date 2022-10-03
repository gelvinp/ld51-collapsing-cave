extends Node2D

export(Vector2) var pushback = Vector2(80.0, -100.0)

var damage: float
var player: KinematicBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.play("default")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_AnimatedSprite_animation_finished():
	queue_free()


func _on_Area2D_body_entered(body):
	if body.get_groups().has("enemy"):
		var pushback_amount = pushback
		var enemy_offset = player.global_position - body.global_position
		pushback_amount.x *= -sign(enemy_offset.x)
		body.hit(damage, pushback_amount)
