#это уровень
extends Node2D

@onready var oparysh = $oparysh
@onready var camera = $oparysh/Camera2D

var zoom_tween: Tween
var camera_follow_enabled: bool = false

signal map_ready

const N = 1
const E = 2
const S = 4
const W = 8

var cell_walls = {Vector2i(0, -1): N, Vector2i(1, 0): E,  Vector2i(0, 1): S, Vector2i(-1, 0): W}

@export var width : int = 23
@export var height : int = 13

@export var generation_time: float = 2.0
@export var visualization_step : int = 5

@onready var Map = $tiles
@onready var tile_size = Map.tile_set.tile_size

func _ready():
	Global.reset()
	Global.map_height = height
	Global.map_width = width
	oparysh.position = Global.get_map_center()
	
	await get_tree().process_frame
	
	if camera:
		camera.zoom = Vector2(1, 1)
		camera_follow_enabled = false
		camera.position_smoothing_enabled = false
		set_camera_to_full_map()
	
	Map.tile_set = Map.tile_set
	
	randomize()
	make_maze()

func check_neighbors(cell: Vector2i, unvisited: Array) -> Array:
	var list = []
	for n in cell_walls.keys():
		if cell + n in unvisited:
			list.append(cell + n)
	return list

func make_maze():
	Global.playing = false
	
	var unvisited = []
	var stack = []
	var layer = 0
	
	Map.clear()
	
	for x in range(width):
		for y in range(height):
			var pos = Vector2i(x, y)
			unvisited.append(pos)
			Map.set_cell(layer, pos, 1, get_atlas_coords(N|E|S|W), 0)
	
	var current = Vector2i(0, 0)
	unvisited.erase(current)
	
	var step_counter = 0
	
	while unvisited:
		var neighbors = check_neighbors(current, unvisited)
		if neighbors.size() > 0:
			var next = neighbors[randi() % neighbors.size()]
			stack.append(current)
			
			var dir = next - current
			
			remove_wall_between(current, next, dir)
			
			current = next
			unvisited.erase(current)
		elif stack:
			current = stack.pop_back()
		#await get_tree().process_frame
		step_counter += 1
		
		if generation_time > 0 and step_counter % visualization_step == 0:
			await get_tree().process_frame
	
	
	#replace_floor_tiles()
	await zoom_in_camera()
	map_ready.emit()

func zoom_in_camera():
	if !camera:
		print("no camera bllll")
		Global.playing = true
		return
	
	if zoom_tween:
		zoom_tween.kill()
	
	zoom_tween = create_tween()
	zoom_tween.set_trans(Tween.TRANS_QUINT)
	zoom_tween.set_ease(Tween.EASE_IN_OUT)
	
	zoom_tween.tween_property(camera, "zoom", Vector2(7, 7), 1.0)
	
	await zoom_tween.finished
	set_camera()
	Global.playing = true

func set_camera_to_full_map():
	#var tile_size = Map.tile_set.tile_size
	var map_width_px = width * tile_size.x
	var map_height_px = height * tile_size.y
	var viewport_size = get_viewport().get_visible_rect().size
	
	var zoom_x = viewport_size.x / map_width_px
	var zoom_y = viewport_size.y / map_height_px
	var full_map_zoom = max(zoom_x, zoom_y)
	
	camera.zoom = Vector2(full_map_zoom, full_map_zoom)
	
	var map_center = Vector2(map_width_px / 2, map_height_px / 2)
	oparysh.position = map_center
	
	camera.position = Vector2.ZERO

func remove_wall_between(current: Vector2i, next: Vector2i, dir: Vector2i):
	var layer = 0
	var current_walls = get_walls_at(current)
	var next_walls = get_walls_at(next)
	
	match dir:
		Vector2i.UP:
			current_walls &= ~N
			next_walls &= ~S
		Vector2i.DOWN:
			current_walls &= ~S
			next_walls &= ~N
		Vector2i.LEFT:
			current_walls &= ~W
			next_walls &= ~E
		Vector2i.RIGHT:
			current_walls &= ~E
			next_walls &= ~W
		
	Map.set_cell(layer, current, 1, get_atlas_coords(current_walls), 0)
	Map.set_cell(layer, next, 1, get_atlas_coords(next_walls), 0)

func get_walls_at(_position: Vector2i) -> int:
	var layer = 0
	var atlas_coords = Map.get_cell_atlas_coords(layer, _position)
	
	var coords_to_wall = {
		Vector2i(0, 0): 0,
		Vector2i(1, 0): 1,
		Vector2i(2, 0): 2,
		Vector2i(3, 0): 3,
		Vector2i(0, 1): 4,
		Vector2i(1, 1): 5,
		Vector2i(2, 1): 6,
		Vector2i(3, 1): 7,
		Vector2i(0, 2): 8,
		Vector2i(1, 2): 9,
		Vector2i(2, 2): 10,
		Vector2i(3, 2): 11,
		Vector2i(0, 3): 12,
		Vector2i(1, 3): 13,
		Vector2i(2, 3): 14,
		Vector2i(3, 3): 15,
	}
	
	return coords_to_wall.get(atlas_coords, 0)

func get_atlas_coords(walls: int) -> Vector2i:
	var wall_to_coords = {
		0: Vector2i(0, 0),
		1: Vector2i(1, 0),
		2: Vector2i(2, 0),
		3: Vector2i(3, 0),
		4: Vector2i(0, 1),
		5: Vector2i(1, 1),
		6: Vector2i(2, 1),
		7: Vector2i(3, 1),
		8: Vector2i(0, 2),
		9: Vector2i(1, 2),
		10: Vector2i(2, 2),
		11: Vector2i(3, 2),
		12: Vector2i(0, 3),
		13: Vector2i(1, 3),
		14: Vector2i(2, 3),
		15: Vector2i(3, 3),
	}
	return wall_to_coords[walls]

func set_camera():
	var map_left = 0
	var map_top = 0
	var map_right = width * tile_size.x
	var map_bottom = height * tile_size.y
	
	camera.limit_left = map_left
	camera.limit_top = map_top
	camera.limit_right = map_right
	camera.limit_bottom = map_bottom
	
	camera.ignore_rotation = true
