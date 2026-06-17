#это дебаг
extends NinePatchRect

@onready var stick_line = $MarginContainer/VBoxContainer/HBoxContainer2/stick_line
@onready var leaf_line = $MarginContainer/VBoxContainer/HBoxContainer3/leaf_line
@onready var flower_line = $MarginContainer/VBoxContainer/HBoxContainer4/flower_line
@onready var berry_line = $MarginContainer/VBoxContainer/HBoxContainer5/berry_line
@onready var acorn_line = $MarginContainer/VBoxContainer/HBoxContainer/acorn_line
@onready var mushroom_line = $MarginContainer/VBoxContainer/HBoxContainer6/mushroom_line
@onready var raf_line = $MarginContainer/VBoxContainer/HBoxContainer7/raf_line

@onready var toggle_bird_button = $MarginContainer/VBoxContainer/toggle_bird

var sticks
var leaves
var flowers
var berries
var acorns
var mushrooms
var rafs

func _on_apply_debug_pressed() -> void:
	sticks = int(stick_line.text)
	leaves = int(leaf_line.text)
	flowers = int(flower_line.text)
	berries = int(berry_line.text)
	acorns = int(acorn_line.text)
	mushrooms = int(mushroom_line.text)
	rafs = int(raf_line.text)
	
	for i in sticks:
		Global.add_drop("stick")
		Global.eaten += 1
		Global.total += 3
	for i in leaves:
		Global.add_drop("leaf")
		Global.eaten += 1
		Global.total += 1
	for i in flowers:
		Global.add_drop("flower")
		Global.eaten += 1
		Global.total += 5
	for i in berries:
		Global.add_drop("berry")
		Global.eaten += 1
		Global.total += 5
	for i in acorns:
		Global.add_drop("acorn")
		Global.eaten += 1
		Global.total += 20
	for i in mushrooms:
		Global.add_drop("mushroom")
		Global.eaten += 1
		Global.total += 20
	for i in rafs:
		Global.add_drop("raf")
		Global.eaten += 1
		Global.total += 25



func _on_reset_debug_2_pressed() -> void:
	Global.reset()


func _on_toggle_bird_pressed() -> void:
	if Global.is_bird:
		Global.is_bird = false
		toggle_bird_button.text = "no bird"
		
	else:
		Global.is_bird = true
		toggle_bird_button.text = "is bird"
