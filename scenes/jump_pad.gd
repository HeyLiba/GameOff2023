extends Area2D

@export var force : float = 200

func _on_body_entered(body):
	if body is RigidBody2D:
		body.apply_central_impulse(Vector2.UP * force)
