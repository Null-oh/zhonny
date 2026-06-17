#это интерфейс заглавной страницы
extends CanvasLayer

@onready var sprite = $main/NinePatchRect/VBoxContainer/HBoxContainer/Control/AnimatedSprite2D

@onready var collection = $collection
@onready var how_to = $how_to

@onready var label1 = $collection/NinePatchRect/MarginContainer/VBoxContainer/results/GridContainer/but1/but1label
@onready var label2 = $collection/NinePatchRect/MarginContainer/VBoxContainer/results/GridContainer/but2/but2label
@onready var label3 = $collection/NinePatchRect/MarginContainer/VBoxContainer/results/GridContainer/but3/but3label
@onready var label4 = $collection/NinePatchRect/MarginContainer/VBoxContainer/results/GridContainer/frog/froglabel
@onready var label5 = $collection/NinePatchRect/MarginContainer/VBoxContainer/results/GridContainer/beetle/beetlelabel
@onready var label6 = $collection/NinePatchRect/MarginContainer/VBoxContainer/results/GridContainer/hton/htonlabel

@onready var texture1 = $collection/NinePatchRect/MarginContainer/VBoxContainer/results/GridContainer/but1/ColorRect/but1texture
@onready var texture2 = $collection/NinePatchRect/MarginContainer/VBoxContainer/results/GridContainer/but2/ColorRect/but2texture
@onready var texture3 = $collection/NinePatchRect/MarginContainer/VBoxContainer/results/GridContainer/but3/ColorRect/but3texture
@onready var texture4 = $collection/NinePatchRect/MarginContainer/VBoxContainer/results/GridContainer/frog/ColorRect/frogtexture
@onready var texture5 = $collection/NinePatchRect/MarginContainer/VBoxContainer/results/GridContainer/beetle/ColorRect/beetletexture
@onready var texture6 = $collection/NinePatchRect/MarginContainer/VBoxContainer/results/GridContainer/hton/ColorRect/htontexture

@onready var pocketbut1 = $collection/pocketbut1
@onready var pocketbut2 = $collection/pocketbut2
@onready var pocketbut3 = $collection/pocketbut3
@onready var pocketfrog = $collection/pocketfrog
@onready var pocketbeetle = $collection/pocketbeetle
@onready var pockethton = $collection/pockethton

@onready var page1 = $how_to/NinePatchRect/MarginContainer/VBoxContainer/back/MarginContainer/VBoxContainer/page1
@onready var page2 = $how_to/NinePatchRect/MarginContainer/VBoxContainer/back/MarginContainer/VBoxContainer/page2
@onready var page3 = $how_to/NinePatchRect/MarginContainer/VBoxContainer/back/MarginContainer/VBoxContainer/page3
@onready var page4 = $how_to/NinePatchRect/MarginContainer/VBoxContainer/back/MarginContainer/VBoxContainer/page4
@onready var page5 = $how_to/NinePatchRect/MarginContainer/VBoxContainer/back/MarginContainer/VBoxContainer/page5

@onready var forward_button = $how_to/NinePatchRect/MarginContainer/VBoxContainer/back/MarginContainer/VBoxContainer/buttons/forward
@onready var back_button = $how_to/NinePatchRect/MarginContainer/VBoxContainer/back/MarginContainer/VBoxContainer/buttons/back
var current_page : int

func _ready():
	sprite.play("default")
	
	collection.visible = false
	how_to.visible = false
	
	setup_texture(texture1)
	setup_texture(texture2)
	setup_texture(texture3)
	setup_texture(texture4)
	setup_texture(texture5)
	setup_texture(texture6)
	update_collection()
	
	pocketbut1.visible = false
	pocketbut2.visible = false
	pocketbut3.visible = false
	pocketfrog.visible = false
	pocketbeetle.visible = false
	pockethton.visible = false
	
	load_pockets()
	
	page1.visible = false
	page2.visible = false
	page3.visible = false
	page4.visible = false
	page5.visible = false
	current_page = 1

func setup_texture(texture_rect: TextureRect):
	var color_rect = texture_rect.get_parent()
	
	color_rect.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	color_rect.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	
	texture_rect.anchor_left = 0.0
	texture_rect.anchor_top = 0.0
	texture_rect.anchor_right = 1.0
	texture_rect.anchor_bottom = 1.0
	texture_rect.offset_left = 0
	texture_rect.offset_top = 0
	texture_rect.offset_right = 0
	texture_rect.offset_bottom = 0
	
	texture_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED

func update_collection():
	var current_results = Global.results
	
	if "but1" in current_results:
		label1.text = "МАЛЕНЬКАЯ БАБЧКА"
		texture1.texture = preload("res://img/but1.png")
	else:
		label1.text = "???"
		texture1.texture = preload("res://img/some_texture.png")
	
	if "but2" in current_results: 
		label2.text = "БОЛЬШАЯ БАБЧКА"
		texture2.texture = preload("res://img/but2.png")
	else:
		label2.text = "???"
		texture2.texture = preload("res://img/some_texture.png")
	
	if "but3" in current_results:  
		label3.text = "ПАФОСНАЯ БАБЧКА"
		texture3.texture = preload("res://img/but3.png")
	else:
		label3.text = "???"
		texture3.texture = preload("res://img/some_texture.png")
	
	if "frog" in current_results:  
		label4.text = "ЛЕГУЧКА"
		texture4.texture = preload("res://img/frog.png")
	else:
		label4.text = "???"
		texture4.texture = preload("res://img/some_texture.png")
	
	if "beetle" in current_results:  
		label5.text = "МАЙСКИЙ ЖУЧ"
		texture5.texture = preload("res://img/beetle.png")
	else:
		label5.text = "???"
		texture5.texture = preload("res://img/some_texture.png")
	
	if "hton" in current_results:  
		label6.text = "ХТОНИЧЕСКИЙ НЕФОР"
		texture6.texture = preload("res://img/hton.png")
	else:
		label6.text = "???"
		texture6.texture = preload("res://img/some_texture.png")

func _on_start_pressed():
	get_tree().change_scene_to_file("res://scenes/level.tscn")

func _on_how_to_pressed():
	how_to.visible = true
	page1.visible = true
	back_button.disabled = true
	current_page = 1

func _on_back_how_to_pressed() -> void:
	flip_page("back")

func _on_forward_how_to_pressed() -> void:
	flip_page("forward")

func flip_page(direction: String):
	match direction:
		"forward":
			match current_page:
				1:
					page1.visible = false
					page2.visible = true
					current_page = 2
					forward_button.disabled = false
					back_button.disabled = false
				2:
					page2.visible = false
					page3.visible = true
					current_page = 3
					forward_button.disabled = false
				3: 
					page3.visible = false
					page4.visible = true
					current_page = 4
					forward_button.disabled = false
				4: 
					page4.visible = false
					page5.visible = true
					current_page = 5
					forward_button.disabled = true
				5: 
					pass
		"back":
			match current_page:
				1: 
					pass
				2: 
					page1.visible = true
					page2.visible = false
					current_page = 1
					back_button.disabled = true
					forward_button.disabled = false
				3: 
					page2.visible = true
					page3.visible = false
					current_page = 2
					back_button.disabled = false
				4: 
					page3.visible = true
					page4.visible = false
					current_page = 3
					back_button.disabled = false
				5: 
					page4.visible = true
					page5.visible = false
					current_page = 4
					forward_button.disabled = false

func _on_collection_pressed():
	collection.visible = true

func _on_exit_pressed():
	get_tree().quit()

func _on_back_pressed():
	collection.visible = false
	how_to.visible = false
	current_page = 1

func _on_reset_pressed():
	Global.reset_results()
	load_pockets()

func load_pockets():
	var but1pocket = pocketbut1.find_child("pocket_drops", true, false)
	var but2pocket = pocketbut2.find_child("pocket_drops", true, false)
	var but3pocket = pocketbut3.find_child("pocket_drops", true, false)
	var frogpocket = pocketfrog.find_child("pocket_drops", true, false)
	var beetlepocket = pocketbeetle.find_child("pocket_drops", true, false)
	var htonpocket = pockethton.find_child("pocket_drops", true, false)
	
	if !but1pocket:
		print("no but1pocket")
		return
	
	for child in but1pocket.get_children():
		child.queue_free()
	for child in but2pocket.get_children():
		child.queue_free()
	for child in but3pocket.get_children():
		child.queue_free()
	for child in frogpocket.get_children():
		child.queue_free()
	for child in beetlepocket.get_children():
		child.queue_free()
	for child in htonpocket.get_children():
		child.queue_free()
	
	if Global.pockets.has("but1"):
		for item in Global.pockets["but1"]:
			for i in range(item["count"]):
				but1pocket.add_child(get_drop_texture(item["name"]))
	if Global.pockets.has("but2"):
		for item in Global.pockets["but2"]:
			for i in range(item["count"]):
				but2pocket.add_child(get_drop_texture(item["name"]))
	if Global.pockets.has("but3"):
		for item in Global.pockets["but3"]:
			for i in range(item["count"]):
				but3pocket.add_child(get_drop_texture(item["name"]))
	if Global.pockets.has("frog"):
		for item in Global.pockets["frog"]:
			for i in range(item["count"]):
				frogpocket.add_child(get_drop_texture(item["name"]))
	if Global.pockets.has("beetle"):
		for item in Global.pockets["beetle"]:
			for i in range(item["count"]):
				beetlepocket.add_child(get_drop_texture(item["name"]))
	if Global.pockets.has("hton"):
		for item in Global.pockets["hton"]:
			for i in range(item["count"]):
				htonpocket.add_child(get_drop_texture(item["name"]))

func get_drop_texture(drop_name: String) -> TextureRect:
	var item_texture = TextureRect.new()
	var texture = load_item_texture(drop_name)
	
	if texture:
		item_texture.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		item_texture.texture = texture
	
	item_texture.custom_minimum_size = Vector2(50, 50)
	item_texture.size = Vector2(50, 50)
	
	item_texture.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
	item_texture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	
	return item_texture

func load_item_texture(drop_name: String) -> Texture2D:
	match drop_name:
		"leaf":
			return preload("res://img/leaf_texture.png")
		"flower": 
			return preload("res://img/flower_texture.png")
		"stick":
			return preload("res://img/stick_texture.png")
		"berry": 
			return preload("res://img/berry_texture.png")
		"mushroom": 
			return preload("res://img/mushroom_texture.png")
		"acorn": 
			return preload("res://img/acorn_texture.png")
		"raf": 
			return preload("res://img/raf_texture.png")
		_: return null

func _on_b_1_pocket_pressed():
	pocketbut1.visible = true

func _on_b_2_pocket_pressed():
	pocketbut2.visible = true

func _on_b_3_pocket_pressed():
	pocketbut3.visible = true

func _on_frogpocket_pressed():
	pocketfrog.visible = true

func _on_beetlepocket_pressed():
	pocketbeetle.visible = true

func _on_htonpocket_pressed():
	pockethton.visible = true

func _on_close_pocket_pressed():
	pocketbut1.visible = false
	pocketbut2.visible = false
	pocketbut3.visible = false
	pocketfrog.visible = false
	pocketbeetle.visible = false
	pockethton.visible = false
