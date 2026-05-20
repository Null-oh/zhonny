#это глобал
extends Node

var playing : bool = false

var map_height : int
var map_width : int
var tile_size : int = 64

var health : int = 100
var speed : int = 40

var max_time : float = 60
var time : float = max_time

var bonus : bool = false

var total : int = 0

var drops = []
var results = []

func reset():
	health = 100
	speed = 40
	total = 0
	time = max_time
	bonus = false
	drops = []

func reset_results():
	results = []

func add_drop(item_name: String):
	print("Added to Global: ", item_name)
	for drop in drops:
		if drop["name"] == item_name:
			drop["count"] += 1
			return
	drops.append({"name": item_name, "count": 1})

func count_drops(item_name: String) -> int:
	for drop in drops:
		if drop["name"] == item_name:
			return drop["count"]
	return 0

func add_result(result_name: String):
	print("Added result: ", result_name)
	if result_name not in results:
		results.append(result_name)

func get_map_center() -> Vector2 :
	var x = map_width * tile_size * 0.5
	var y = map_height * tile_size * 0.5
	return Vector2(x, y)
