extends CanvasLayer

@onready var sprite = $main/NinePatchRect/VBoxContainer/HBoxContainer/Control/AnimatedSprite2D

@onready var collection = $collection
@onready var how_to = $how_to

func _ready():
	sprite.play("default")
	
	collection.visible = false
	how_to.visible = false

func _process(delta):
	pass


func _on_start_pressed():
	get_tree().change_scene_to_file("res://scenes/level.tscn")


func _on_how_to_pressed():
	how_to.visible = true


func _on_collection_pressed():
	collection.visible = true


func _on_exit_pressed():
	get_tree().quit()


func _on_back_pressed():
	collection.visible = false
	how_to.visible = false


func _on_reset_pressed():
	print(Global.results)
	Global.reset_results()
	print(Global.results)
