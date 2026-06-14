#это птица
extends Node2D

@onready var shadow = $shadow
@onready var sprite = $shadow/Sprite2D
@onready var area = $shadow/Area2D

var timer : float = 3.0

var shadow_tween : Tween
var can_hit : bool = false
var is_following : bool = false

var oparysh = null

var active_tweens : Array[Tween] = []
var is_paused : bool = false

func _ready():
	sprite.visible = false
	area.visible = false
	area.monitoring = false
	
	Global.connect("playing_changed", Callable(self, "_on_playing_changed"))
	
	shadow.offset = Vector2(0, 0)
	shadow.modulate = Color(1, 1, 1, 0)
	shadow.scale = Vector2(1, 1)
	
	can_hit = false
	
	area.body_entered.connect(_on_area_2d_body_entered)
	
	shadow_animation()

func _process(_delta):
	if is_following and oparysh and is_instance_valid(oparysh):
		shadow.global_position = oparysh.global_position

func shadow_animation():
	if Global.playing and oparysh:
		shadow.global_position = oparysh.global_position
		
		shadow.modulate.a = 0.0
		
		shadow_tween = create_tween()
		active_tweens.append(shadow_tween)
		shadow_tween.set_parallel(true)
		
		shadow_tween.tween_property(shadow, "modulate:a", 0.8, timer)\
				   .set_trans(Tween.TRANS_QUAD)\
				   .set_ease(Tween.EASE_IN)
		
		is_following = true
		await shadow_tween.finished
		
		if oparysh.velocity.length() > 0:
			var offset_direction = oparysh.direction
			var target_position = oparysh.global_position + (offset_direction * 25)
			
			var move_tween = create_tween()
			move_tween.tween_property(shadow, "global_position", target_position, 0.1)\
				.set_trans(Tween.TRANS_QUAD)\
				.set_ease(Tween.EASE_OUT)
			await move_tween.finished
		else:
			pass
		
		is_following = false
		drop()

func _on_playing_changed(new_value):
	if new_value:
		is_paused = false
		for tween in active_tweens:
			if tween and tween.is_valid():
				tween.play()
	else:
		is_paused = true
		for tween in active_tweens:
			if tween and tween.is_valid():
				tween.pause()

func drop(): 
	is_following = false
	
	sprite.position = Vector2(200, -200)
	sprite.visible = true
	
	var bird_tween: Tween = create_tween()
	active_tweens.append(bird_tween)
	var fall_duration = 0.8
	
	bird_tween.tween_property(sprite, "position", Vector2(0, 25), fall_duration)\
			  .set_trans(Tween.TRANS_QUAD)\
			  .set_ease(Tween.EASE_IN)
	
	var hit_window = 0.1
	
	var hit_timer = get_tree().create_timer(fall_duration + hit_window)
	hit_timer.timeout.connect(_enable_hit_area)
	
	await bird_tween.finished
	
	var intensity : float = get_intensity()
	shake_camera(0.2, intensity)
	
	can_hit = false
	
	if area:
		area.visible = false
	
	bird_tween = create_tween()
	active_tweens.append(bird_tween)
	
	bird_tween.tween_property(sprite, "position", Vector2(-200, -200), fall_duration)\
			  .set_trans(Tween.TRANS_QUAD)\
			  .set_ease(Tween.EASE_IN)
	
	await bird_tween.finished
	self.queue_free()

func shake_camera(duration: float = 0.2, intensity: float = 5.0):
	var camera = get_viewport().get_camera_2d()
	if not camera:
		return
	
	var start_position = camera.position
	var shake_tween = create_tween()
	
	for i in range(10):
		var random_offset = Vector2(
			randf_range(-intensity, intensity),
			randf_range(-intensity, intensity),
		)
		var step_duration = duration / 10.0
		shake_tween.tween_property(camera, "position", start_position + random_offset, step_duration)
		shake_tween.tween_property(camera, "position", start_position, duration / 5.0)

func get_intensity() -> float:
	if not oparysh:
		return 1.2
	
	var distance = clamp(global_position.distance_to(oparysh.global_position) / get_viewport().get_visible_rect().size.length()*0.5, 0.0, 1.0)
	return 1.2 - (distance * 1.0)

func _enable_hit_area():
	can_hit = true
	area.monitoring = true
	area.visible = true

func _on_area_2d_body_entered(body):
	if can_hit:
		if body.name == "oparysh":
			if not body.safe:
				Global.health = 0
			can_hit = false

func _exit_tree():
	for tween in active_tweens:
		if tween and tween.is_valid():
			tween.kill()
	active_tweens.clear()
