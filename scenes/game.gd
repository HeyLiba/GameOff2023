extends Node
@export var scenes : Array[PackedScene]
@onready var worlds : Node2D = $Worlds
var scene_index = 0
var loading : bool = false
@onready var lose_sound : AudioStreamPlayer = $Lose
@onready var win_sound : AudioStreamPlayer = $Win

func _ready():
	load_scene()
	Manager.next.connect(load_next_scene)
	Manager.restart.connect(restart)

func _input(event):
	if loading: return
	if event.is_action("Restart"):
		restart()

func restart():
	if loading: return
	lose_sound.play()
	load_scene()

func load_next_scene():
	if loading: return
	win_sound.play()
	scene_index += 1
	load_scene()

func load_scene():
	if loading: return
	loading = true
	var tween = create_tween()
	tween.set_parallel(false)
	if worlds.get_child_count() != 0:
		tween.tween_property(worlds, "modulate", Color.TRANSPARENT,0.5)
		tween.tween_callback(free_last_world)
	tween.tween_callback(add_scene)
	tween.tween_property(worlds, "modulate", Color.WHITE,0.5)
	tween.tween_callback(finish_loading)

func finish_loading():
	loading = false

func free_last_world():
	worlds.get_child(0).queue_free()

func add_scene():
	var new_scene : Node2D = scenes[scene_index].instantiate()
	worlds.call_deferred("add_child",new_scene)
