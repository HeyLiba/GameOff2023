extends RigidBody2D

@export var max_velocity_squered : float = 200
@onready var pin : PinJoint2D = $PinJoint2D
func damage():
	if is_instance_valid(pin):
		pin.queue_free()
		disconnect("body_entered", _on_body_entered)

func _on_body_entered(body):
	if (!is_instance_valid(pin)): return
	if (body is RigidBody2D and body.linear_velocity.length_squared()*body.mass > max_velocity_squered):
		pin.queue_free()
		disconnect("body_entered", _on_body_entered)
