extends Node2D

@export var collision_shape : CollisionShape2D
@export var sprite: Node2D
@export var scale_layers : Array[float]

@onready var alarm : Sprite2D = $Alarm
var current_layer : int = -1

func _ready():
	if (collision_shape == null):
		collision_shape = get_node("../CollisionShape2D")
	if (sprite == null):
		sprite = get_node("../Sprite2D")
	alarm.visible = false

func scale():
	if (not check_timer()):
		return
	
	current_layer+=1
	if (len(scale_layers)-1 > current_layer):
		$AudioStreamPlayer.play()
		var tween = create_tween()
		tween.set_parallel(true)
		tween.set_trans(Tween.TRANS_ELASTIC)
		tween.tween_property(sprite, "scale", sprite.scale * scale_layers[current_layer], .5)
		tween.tween_property(collision_shape, "scale", collision_shape.scale * scale_layers[current_layer], .5)
		start_timer()
		if current_layer == len(scale_layers) - 2:
			alarm.visible = true
	else :
		var tween = create_tween()
		$AudioStreamPlayer2.play()
		tween.tween_property(sprite, "scale", sprite.scale * 2, 0.2).set_trans(Tween.TRANS_SINE)
		tween.tween_callback(explode)

func explode():
	get_parent().queue_free()

func start_timer():
	$Timer.start()

func check_timer() -> bool :
	return $Timer.is_stopped()
