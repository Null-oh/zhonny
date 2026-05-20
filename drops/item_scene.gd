#это сцена дропа
extends Node2D

@onready var interface = get_tree().root.get_node("level/interface")

@onready var sprite = $Sprite2D
@export var image: Texture2D
@onready var area = $Area2D

var drop_price: int
var drop_name: String = ""

func _ready():
	add_to_group("drops")
	if image and sprite:
		sprite.texture = image

func setup(drop_data: Drop):
	drop_price = drop_data.price
	drop_name = drop_data.name
	if sprite and drop_data.texture:
		sprite.texture = drop_data.texture

func _on_area_2d_body_entered(body):
	if body.name == "oparysh":
		Global.total += drop_price
		Global.add_drop(drop_name)
		
		if interface and interface.has_method("print_info"):
			interface.print_info(drop_name)
		
		match drop_name:
			"leaf": 
				Global.time = min(60, Global.time + 1)
			"flower": 
				Global.time = min(60, Global.time + 2)
			"stick": 
				Global.time = min(60, Global.time + 3)
			"raf": 
				Global.time = min(60, Global.time + 15)
				Global.bonus = true
				if Global.speed <= 150:
					Global.speed += 20
				else: Global.speed = 150
			"mushroom":
				Global.time = min(60, Global.time + 10)
				Global.bonus = true
				if Global.speed >= 20:
					Global.speed -= 20
				else: Global.speed = 20
			"berry":
				Global.time = min(60, Global.time + 5)
		queue_free()
