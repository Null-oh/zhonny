#это птица
extends Node2D

@onready var shadow = $shadow
@onready var sprite = $Sprite2D
@onready var area = $Area2D

var timer : float = 3.0
var t : float = 0
var shadow_tween: Tween
var can_hit: bool = false

func _ready():
	sprite.visible = false
	area.visible = false
	area.monitoring = false
	
	shadow.offset = Vector2(0, 0)
	shadow.modulate = Color(1, 1, 1, 0)
	shadow.scale = Vector2(1, 1)
	
	can_hit = false
	
	area.body_entered.connect(_on_area_2d_body_entered)
	
	shadow_animation()

func shadow_animation():
	if Global.playing:
		shadow_tween = create_tween()
		shadow_tween.set_parallel(true)
		
		shadow_tween.tween_property(shadow, "scale", Vector2(0, 0), timer)\
				   .set_trans(Tween.TRANS_QUAD)\
				   .set_ease(Tween.EASE_IN)
		
		shadow_tween.tween_property(shadow, "modulate:a", 1.0, timer)\
				   .set_trans(Tween.TRANS_QUAD)\
				   .set_ease(Tween.EASE_IN)
		
		await shadow_tween.finished
		drop()

func _process(delta):
	pass

func drop(): 
	sprite.position = Vector2(0, -200)
	sprite.visible = true
	
	var bird_tween: Tween = create_tween()
	var fall_duration = 0.5
	
	bird_tween.tween_property(sprite, "position", Vector2(0, -64), fall_duration)\
			  .set_trans(Tween.TRANS_QUAD)\
			  .set_ease(Tween.EASE_IN)
	
	var hit_window = 0.1
	
	var timer = get_tree().create_timer(fall_duration + hit_window)
	timer.timeout.connect(_enable_hit_area)
	
	await bird_tween.finished
	
	can_hit = false
	
	if area:
		area.visible = false
	
	bird_tween = create_tween()
	bird_tween.tween_property(sprite, "position", Vector2(0, -200), fall_duration)\
			  .set_trans(Tween.TRANS_QUAD)\
			  .set_ease(Tween.EASE_OUT)
	
	await bird_tween.finished
	self.queue_free()

func _enable_hit_area():
	can_hit = true
	area.monitoring = true
	area.visible = true
	print("Area активирована на позиции: ", global_position)

func _on_area_2d_body_entered(body):
	if can_hit and body.name == "oparysh":
		Global.health = 0
		can_hit = false
