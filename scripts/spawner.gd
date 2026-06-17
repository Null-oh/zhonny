#это спавнер
extends Node2D

@onready var map_height : int
@onready var map_width : int
@onready var tile_size : int

@export var drops : Array[DropSlot] = []
@onready var bird = preload("res://assets/bird.tscn")
@export var bird_timer: float = 10.0
var t : float = 0.0

@onready var oparysh = get_tree().get_root().get_node("level/oparysh")
@onready var map = get_tree().get_root().get_node("level/tiles")

func _ready():
	t = 0.0
	
	var level = get_tree().current_scene
	if level.has_signal("map_ready"):
		level.map_ready.connect(_on_map_ready)
	else:
		await get_tree().process_frame
		spawn_drops()

func _process(delta):
	if Global.playing:
		if t <= bird_timer:
			t+= delta
		else:
			t = 0
			if Global.is_bird:
				spawn_bird()

func _on_map_ready():
	spawn_drops()

func spawn_drops():
	map_width = Global.map_width
	map_height = Global.map_height
	tile_size = Global.tile_size

	var centers = get_tile_centers()
	centers.shuffle()
	
	var used_centers = 0
	
	for slot in drops:
		if slot == null or slot.drop == null:
			continue
		
		for i in range(slot.quantity):
			if used_centers >= centers.size():
				print("Перебор")
				return
			
			var drop_instance = slot.drop.scene.instantiate()
			
			if drop_instance.has_method("setup"):
				drop_instance.setup(slot.drop)
			
			if drop_instance.has_node("Sprite2D"):
				drop_instance.get_node("Sprite2D").texture = slot.drop.texture
			else:
				drop_instance.image = slot.drop.texture
			
			drop_instance.position = centers[used_centers]
			add_child(drop_instance)
			used_centers += 1

func get_tile_centers() -> Array:
	var total = int(map_width * map_height)
	var centers : Array[Vector2] = []
	centers.resize(total)
	
	for y in range(map_height):
		for x in range(map_width):
			var index = y * map_width + x
			centers[index] = Vector2(
				tile_size * (x + 0.5),
				tile_size * (y + 0.5)
			)
	return centers

func spawn_bird():
	if not oparysh: 
		print("oparysh gde")
		return
	
	var bird_instance = bird.instantiate()
	bird_instance.oparysh = oparysh
	add_child(bird_instance)
	bird_instance.shadow_animation("down")
