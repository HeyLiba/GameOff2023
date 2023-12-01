extends RigidBody2D

@onready var state_chart : StateChart = $StateChart
@onready var grounded_area : Area2D = $Grounded
@onready var front_ray : RayCast2D = $FrontRay
@onready var up_ray : RayCast2D = $UpRay
@onready var anim : AnimationPlayer = $AnimationPlayer
@onready var sprite : Sprite2D = $Body

var inputX : float
@export var max_x_speed : float = 5
@export var acceleration : float = 5
@export var jump_force : float = 5
@export var ledge_grab_jump_force : float = 200
@export var friction : float = .5
@export var fall_gravity_scale : float = 1.2
@export var pick_force : float = 30

var _base_body_scale_x : float

# both rays shoude have the same x value
var _base_front_ray_target_x : float
var _base_gravity_scale : float

func _ready():
	_base_front_ray_target_x = front_ray.target_position.x
	_base_gravity_scale = gravity_scale
	_base_body_scale_x = sprite.scale.x

func _process(_delta):
	get_input()

func _physics_process(_delta):
	handle_movement()
	check_gun()
	
	apply_central_force(-linear_velocity.x * Vector2.RIGHT * friction)
	
	if grounded_area.monitoring && grounded_area.has_overlapping_bodies():
		state_chart.send_event("grounded")
	else:
		state_chart.send_event("ungrounded")

func check_gun():
	$Gun.look_at(get_global_mouse_position())
	var gun_and_body_Are_in_same_direction : bool = (transform.x.x * $Gun.transform.x.x) > 0
	sprite.scale.x = _base_body_scale_x if gun_and_body_Are_in_same_direction else -_base_body_scale_x
	$Gun/Sprite2D.flip_v = not gun_and_body_Are_in_same_direction
	var col = $Gun.get_collider()
	if ($Gun.is_colliding() and col):
		if (col.has_method("damage")):
			col.damage()
		var scalable = col.get_node_or_null("Scalable")
		if scalable:
			scalable.scale()
	if $Gun.enabled:
		$Gun/Sprite2D/Line2D.visible = true
		call_deferred("draw_gun_line")
	else:
		$Gun/Sprite2D/Line2D.visible = false

func draw_gun_line():
	if $Gun.is_colliding():
		$Gun/Sprite2D/Line2D.set_point_position(1,$Gun/Sprite2D/Line2D.to_local($Gun.get_collision_point()))
	else:
		$Gun/Sprite2D/Line2D.set_point_position(1,$Gun.target_position)

func get_input():
	inputX = Input.get_axis("Left","Right")
	
	$Gun.enabled = Input.get_action_raw_strength("Gun")
	if Input.is_action_just_pressed("Gun"):
		$shoot.play()

func handle_movement():
	if (abs(linear_velocity.x) < max_x_speed):
		apply_central_force(Vector2.RIGHT * inputX * acceleration)

func jump_check(_delta):
	if (Input.is_action_pressed("Jump")):
		linear_velocity.y = -jump_force
		state_chart.send_event("jump")
		$jump.play()
		grounded_area.monitoring = false
		$GroundMonitoringTimer.start()

## pevent the state machine to return to grounded state just after you press jump
func _on_ground_monitoring_timer_timeout():
	grounded_area.monitoring = true


func _on_rise_state_physics_processing(_delta):
	if linear_velocity.y >= 0:
		state_chart.send_event("fall")

func _on_fall_state_entered():
	gravity_scale = fall_gravity_scale
	up_ray.enabled = true
func _on_fall_state_exited():
	gravity_scale = _base_gravity_scale


func _on_un_grounded_state_physics_processing(_delta):
	if inputX > 0:
		front_ray.target_position.x = _base_front_ray_target_x
	elif inputX < 0:
		front_ray.target_position.x = -_base_front_ray_target_x

func _on_front_monitoring_timer_timeout():
	front_ray.enabled = true


func _on_move_state_physics_processing(_delta):
	if (abs(linear_velocity.x) > 10):
		if $AudioStreamPlayer/Timer.time_left <=0:
			$AudioStreamPlayer.pitch_scale = randf_range(.8, 1.2)
			$AudioStreamPlayer.play()
			$AudioStreamPlayer/Timer.start(.3)
		anim.play("Run")
		anim.speed_scale = (linear_velocity.x / max_x_speed) *4 #*2 is hard coded for better feeling
	else:
		anim.speed_scale = 2
		anim.play("Idle")


func _on_move_state_exited():
	anim.speed_scale = 1
