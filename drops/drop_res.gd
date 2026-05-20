#это ресурс дропа
extends Resource
class_name Drop

@export var scene: PackedScene = preload("res://drops/item_scene.tscn")
@export var name = ""
@export var price: int

@export var texture: Texture2D
