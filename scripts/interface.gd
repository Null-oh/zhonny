#это интерфейс
extends CanvasLayer

@onready var oparysh = get_tree().get_root().get_node("level/oparysh")

@onready var timer = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/timer
@onready var bonus = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/bonus

@onready var info = $MarginContainer/VBoxContainer/HBoxContainer/info

@onready var pause = $pause
@onready var fail = $fail
@onready var win = $win

@onready var win_label = $win/MarginContainer/VBoxContainer/win_label
@onready var win_texture = $win/MarginContainer/VBoxContainer/ColorRect/win_texture
@onready var fail_label = $fail/MarginContainer/VBoxContainer/fail_label

@onready var collection = $collection
@onready var label1 = $collection/VBoxContainer/results/GridContainer/but1/but1label
@onready var label2 = $collection/VBoxContainer/results/GridContainer/but2/but2label
@onready var label3 = $collection/VBoxContainer/results/GridContainer/but3/but3label
@onready var label4 = $collection/VBoxContainer/results/GridContainer/frog/froglabel
@onready var label5 = $collection/VBoxContainer/results/GridContainer/beetle/beetlelabel
@onready var label6 = $collection/VBoxContainer/results/GridContainer/hton/htonlabel

@onready var texture1 = $collection/VBoxContainer/results/GridContainer/but1/ColorRect/but1texture
@onready var texture2 = $collection/VBoxContainer/results/GridContainer/but2/ColorRect/but2texture
@onready var texture3 = $collection/VBoxContainer/results/GridContainer/but3/ColorRect/but3texture
@onready var texture4 = $collection/VBoxContainer/results/GridContainer/frog/ColorRect/frogtexture
@onready var texture5 = $collection/VBoxContainer/results/GridContainer/beetle/ColorRect/beetletexture
@onready var texture6 = $collection/VBoxContainer/results/GridContainer/hton/ColorRect/htontexture


@onready var drop_container = $MarginContainer/VBoxContainer/drops
const ITEM_DISPLAY_TIME = 5.0
const ITEM_FADE_TIME = 3.0


var time : float

var bonus_tween: Tween = null
var bonus_active : bool = false

func _ready():
	info.text = ""
	
	bonus.visible = false
	bonus.max_value = 100
	bonus.value = 100
	
	timer.min_value = 0
	timer.max_value = Global.max_time
	timer.value = Global.max_time
	
	Global.time = Global.max_time
	Global.speed = 40
	Global.playing = true
	
	pause.visible = false
	fail.visible = false
	win.visible = false
	collection.visible = false
	
	label1.text = "???"
	label2.text = "???"
	label3.text = "???"
	label4.text = "???"
	label5.text = "???"
	label6.text = "???"
	
	setup_texture(texture1)
	setup_texture(texture2)
	setup_texture(texture3)
	setup_texture(texture4)
	setup_texture(texture5)
	setup_texture(texture6)
	
	setup_win_texture()
	
	texture1.texture = preload("res://img/some_texture.png")
	texture2.texture = preload("res://img/some_texture.png")
	texture3.texture = preload("res://img/some_texture.png")
	texture4.texture = preload("res://img/some_texture.png")
	texture5.texture = preload("res://img/some_texture.png")
	texture6.texture = preload("res://img/some_texture.png")
	
	win_texture.visible = false

func _process(delta):
	if !Global.playing: return
	
	if Global.time > 0:
		Global.time -= delta
		
	if Global.bonus:
		get_bonus()
	
	if Global.time <= 0 and Global.playing:
		won()
	
	if Global.health <= 0:
		failed()
	
	write()

func write():
	timer.value = max(0, Global.time)

func print_info(drop_name: String):
	add_item(drop_name)
	
	match drop_name:
		"leaf": info.text = "+ 1 c"
		"flower": info.text = "+ 2 c"
		"stick": info.text = "+ 3 c"
		"berry": info.text = "+ 5 c"
		"mushroom": info.text = "+ 10 c"
		"acorn": info.text = "+ 10 c"
		"raf": info.text = "+ 15 c"
	await get_tree().create_timer(2.0).timeout
	info.text = ""

func get_bonus():
	if bonus_active:
		if bonus_tween and bonus_tween.is_valid():
			bonus_tween.kill()
			bonus_tween = null
		
		bonus.value = 100
		
		bonus_tween = create_tween()
		bonus_tween.tween_property(bonus, "value", 0, 5.0)
		bonus_tween.finished.connect(_on_bonus_finished)
		
		Global.bonus = false
	else:
		bonus_active = true
		bonus.visible = true
		bonus.value = 100
		
		bonus_tween = create_tween()
		bonus_tween.tween_property(bonus, "value", 0, 5.0)
		bonus_tween.finished.connect(_on_bonus_finished)
		
		Global.bonus = false

func _on_bonus_finished():

	bonus.visible = false
	bonus.value = 100
	
	Global.bonus = false
	Global.speed = 40
	
	bonus_tween = null
	bonus_active = false

func failed():
	Global.playing = false
	fail.visible = true
	fail_label.text = "ВАС СОЖРАЛИ..."

func won():
	win_texture.visible = true
	
	var result : String
	Global.playing = false
	if oparysh and oparysh.has_method("hatch"):
		result = oparysh.hatch()
	
	match result:
		"but1":
			win_label.text = "ВЫ СТАЛИ\nМАЛЕНЬКОЙ БАБЧКОЙ!"
			win_texture.texture = preload("res://img/but1.png")
		"but2": 
			win_label.text = "ВЫ СТАЛИ\nБОЛЬШОЙ БАБЧКОЙ!"
			win_texture.texture = preload("res://img/but2.png")
		"but3": 
			win_label.text = "ВЫ СТАЛИ\nПАФОСНОЙ БАБЧКОЙ!"
			win_texture.texture = preload("res://img/but3.png")
		"beetle": 
			win_label.text = "ВЫ СТАЛИ\nМАЙСКИМ ЖУЧОМ!"
			win_texture.texture = preload("res://img/beetle.png")
		"frog":
			win_label.text = "ВЫ СТАЛИ\nЛЕГУЧКОЙ!"
			win_texture.texture = preload("res://img/frog.png")
		"hton": 
			win_label.text = "ВЫ СТАЛИ\nХТОНИЧЕСКИМ НЕФОРОМ!"
			win_texture.texture = preload("res://img/hton.png")
		"explode": 
			win_label.text = "ВЫ ОБОЖРАЛИСЬ\nИ ЛОПНУЛИ..."
			win_texture.visible = false
		"starve":
			win_label.text = "В СЛЕДУЮЩИЙ РАЗ\nКУШАЙТЕ БОЛЬШЕ..."
			win_texture.visible = false
	
	if win_texture.visible and win_texture.texture:
		await get_tree().process_frame
		win_texture.size = win_texture.get_parent().size
		
	
	Global.add_result(result)
	update_collection()
	win.visible = true

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
	#texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED

func setup_win_texture():
	win_texture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	win_texture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED  # Изменено с COVERED на CENTERED
	win_texture.size_flags_horizontal = Control.SIZE_EXPAND
	win_texture.size_flags_vertical = Control.SIZE_EXPAND
	
	var parent = win_texture.get_parent()
	if parent is ColorRect:
		parent.size_flags_horizontal = Control.SIZE_EXPAND
		parent.size_flags_vertical = Control.SIZE_EXPAND
		
		parent.anchor_left = 0.0
		parent.anchor_top = 0.0
		parent.anchor_right = 1.0
		parent.anchor_bottom = 1.0
		parent.offset_left = 0
		parent.offset_top = 0
		parent.offset_right = 0
		parent.offset_bottom = 0
		
		parent.color = Color(1, 1, 1, 0) 
	
	win_texture.anchor_left = 0.0
	win_texture.anchor_top = 0.0
	win_texture.anchor_right = 1.0
	win_texture.anchor_bottom = 1.0
	win_texture.offset_left = 10
	win_texture.offset_top = 10
	win_texture.offset_right = -10
	win_texture.offset_bottom = -10
	
	win_texture.size_flags_horizontal = Control.SIZE_EXPAND
	win_texture.size_flags_vertical = Control.SIZE_EXPAND

func update_collection():
	var current_results = Global.results
	
	if "but1" in current_results:
		label1.text = "Маленькая бабчка"
		texture1.texture = preload("res://img/but1.png")
	else:
		label1.text = "???"
		texture1.texture = preload("res://img/some_texture.png")
	
	if "but2" in current_results: 
		label2.text = "Большая бабчка"
		texture2.texture = preload("res://img/but2.png")
	else:
		label2.text = "???"
		texture2.texture = preload("res://img/some_texture.png")
	
	if "but3" in current_results:  
		label3.text = "Пафосная бабчка"
		texture3.texture = preload("res://img/but3.png")
	else:
		label3.text = "???"
		texture3.texture = preload("res://img/some_texture.png")
	
	if "frog" in current_results:  
		label4.text = "Легучка"
		texture4.texture = preload("res://img/frog.png")
	else:
		label4.text = "???"
		texture4.texture = preload("res://img/some_texture.png")
	
	if "beetle" in current_results:  
		label5.text = "Майский жуч"
		texture5.texture = preload("res://img/beetle.png")
	else:
		label5.text = "???"
		texture5.texture = preload("res://img/some_texture.png")
	
	if "hton" in current_results:  
		label6.text = "Хтонический нефор"
		texture6.texture = preload("res://img/hton.png")
	else:
		label6.text = "???"
		texture6.texture = preload("res://img/some_texture.png")

func add_item(drop_name: String):
	var item_texture = TextureRect.new()
	var texture = load_item_texture(drop_name)
	
	if texture:
		item_texture.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		item_texture.texture = texture
	
	item_texture.custom_minimum_size = Vector2(50, 50)
	item_texture.size = Vector2(50, 50)
	
	item_texture.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
	item_texture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	
	drop_container.add_child(item_texture)
	drop_container.move_child(item_texture, 0)
	
	animate_item_removal(item_texture)

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

func animate_item_removal(item_texture: TextureRect):
	await get_tree().create_timer(ITEM_DISPLAY_TIME).timeout
	var tween = create_tween()
	tween.tween_property(item_texture, "modulate", Color(1, 1, 1, 0), ITEM_FADE_TIME)
	tween.tween_callback(item_texture.queue_free)

func _on_pause_pressed():
	Global.playing = false
	pause.visible = true

func _on_continue_pressed():
	pause.visible = false
	Global.playing = true

func _on_collection_pressed():
	collection.visible = true
	Global.playing = false

func _on_exit_pressed():
	get_tree().change_scene_to_file("res://scenes/start_new.tscn")

func _on_restart_pressed():
	get_tree().reload_current_scene()

func _on_reset_pressed():
	Global.playing = false
	Global.reset_results()
	update_collection()

func _on_back_pressed():
	collection.visible = false
	Global.playing = false
