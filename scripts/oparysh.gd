#это опарыш
extends CharacterBody2D

@onready var sprite = $sprite

@onready var health = Global.health
@onready var speed = Global.speed

@onready var drops_in_group = get_tree().get_nodes_in_group("drops")

@onready var total_drops

var direction: Vector2

var target_position: Vector2
var is_moving : bool = false
var is_dragging: bool = false
var stop_distance: float = 1.0

var start_position: Vector2

func _ready():
	add_to_group("oparysh")
	sprite.play("idle")
	sprite.flip_v = false

func hatch() -> String:
	total_drops = Global.drops
	print(total_drops)
	
	if Global.total > 500:
		return "explode"
	elif Global.total < 100:
		return "starve"
	elif Global.count_drops("raf") >= 5:
		return "hton"
	elif Global.count_drops("raf") > 1:
		return "but3"
	elif Global.count_drops("mushroom") >= 5:
		return "frog"
	elif Global.count_drops("acorn") >= 5:
		return "beetle"
	elif Global.count_drops("leaf") > 0 and \
		Global.count_drops("flower") > 0 and \
		Global.count_drops("stick") > 0 and \
		Global.count_drops("acorn") > 0 and \
		Global.count_drops("mushroom") > 0 and \
		Global.count_drops("berry") > 0:
			return "but2"
	else:
		return "but1"

func _process(delta):
	speed = Global.speed
	if is_moving: 
		direction = global_position.direction_to(target_position)
		velocity = direction * speed
		if Global.playing:
			move_and_slide()
		
		if abs(direction.x) > abs(direction.y):
			sprite.play("side")
			sprite.flip_h = direction.x > 0
			sprite.flip_v = false
		else:
			sprite.play("up")
			sprite.flip_v = direction.y > 0
		
		var distance = global_position.distance_to(target_position)
		if distance < stop_distance:
			velocity = Vector2.ZERO
			is_moving = false
			global_position = target_position
	else:
		sprite.play("idle")
		sprite.flip_v = false


func _input(event):
	if (event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT):
		if _is_click_on_ui():
			return
		target_position = get_global_mouse_position()
		is_moving = true
		is_dragging = true
	
	if event is InputEventMouseMotion and is_dragging:
		target_position = get_global_mouse_position()
		is_moving = true
	
	elif (event is InputEventMouseButton and not event.pressed and event.button_index == MOUSE_BUTTON_LEFT):
		is_dragging = false 

func _is_click_on_ui():
	var mouse_pos = get_viewport().get_mouse_position()
	var ui_elements = get_tree().get_nodes_in_group("ui")
	for element in ui_elements:
		if element is Control and element.visible:
			var rect = Rect2(element.global_position, element.size)
			if rect.has_point(mouse_pos):
				return true
	return false
