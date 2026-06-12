extends Node2D

@onready var collection = $CanvasLayer/collection
@onready var label1 = $CanvasLayer/collection/VBoxContainer/results/GridContainer/but1/but1label
@onready var label2 = $CanvasLayer/collection/VBoxContainer/results/GridContainer/but2/but2label
@onready var label3 = $CanvasLayer/collection/VBoxContainer/results/GridContainer/but3/but3label
@onready var label4 = $CanvasLayer/collection/VBoxContainer/results/GridContainer/frog/froglabel
@onready var label5 = $CanvasLayer/collection/VBoxContainer/results/GridContainer/beetle/beetlelabel
@onready var label6 = $CanvasLayer/collection/VBoxContainer/results/GridContainer/hton/htonlabel

@onready var texture1 = $CanvasLayer/collection/VBoxContainer/results/GridContainer/but1/ColorRect/but1texture
@onready var texture2 = $CanvasLayer/collection/VBoxContainer/results/GridContainer/but2/ColorRect/but2texture
@onready var texture3 = $CanvasLayer/collection/VBoxContainer/results/GridContainer/but3/ColorRect/but3texture
@onready var texture4 = $CanvasLayer/collection/VBoxContainer/results/GridContainer/frog/ColorRect/frogtexture
@onready var texture5 = $CanvasLayer/collection/VBoxContainer/results/GridContainer/beetle/ColorRect/beetletexture
@onready var texture6 = $CanvasLayer/collection/VBoxContainer/results/GridContainer/hton/ColorRect/htontexture

@onready var how_to = $CanvasLayer/how_to

@onready var sprite1 = $CanvasLayer/ColorRect/MarginContainer/VBoxContainer2/HBoxContainer/Control/AnimatedSprite2D
@onready var sprite2 = $CanvasLayer/ColorRect/MarginContainer/VBoxContainer2/HBoxContainer/Control2/AnimatedSprite2D

@onready var header = $CanvasLayer/ColorRect/MarginContainer/VBoxContainer2/Label

func _ready():
	collection.visible = false
	setup_texture(texture1)
	setup_texture(texture2)
	setup_texture(texture3)
	setup_texture(texture4)
	setup_texture(texture5)
	setup_texture(texture6)
	update_collection()
	
	how_to.visible = false
	
	sprite1.visible = true
	sprite2.visible = true
	
	sprite1.play("default")
	sprite2.play("default")
	
	header.visible = true

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

func _on_start_pressed():
	get_tree().change_scene_to_file("res://scenes/level.tscn")

func _on_exit_pressed():
	get_tree().quit()

func _on_reset_pressed():
	Global.reset_results()
	update_collection()

func _on_collection_pressed():
	collection.visible = true
	how_to.visible = false
	sprite1.visible = false
	sprite2.visible = false
	header.visible = false

func _on_back_pressed():
	collection.visible = false
	how_to.visible = false
	sprite1.visible = true
	sprite2.visible = true
	header.visible = true

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


func _on_how_to_pressed():
	how_to.visible = true
	sprite1.visible = false
	sprite2.visible = false
	header.visible = false
