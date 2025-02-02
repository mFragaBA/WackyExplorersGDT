extends Node
class_name ItemManager

@export var item_types : Array[Item]

var base_item = preload("res://base_item.tscn")

@export var MAX_DISTANCE = 1000
@export var SPAWN_COUNT = 50

var item_positions = []
var is_item_picked_up = []
var remaining_items = 0
var rng = RandomNumberGenerator.new()

func spawn_items() -> void:
	remaining_items = SPAWN_COUNT
	for i in range(SPAWN_COUNT):
		# https://mathworld.wolfram.com/DiskPointPicking.html
		var random_angle = randf_range(0, 2 * PI)
		var random_distance = randf_range(0, MAX_DISTANCE ** 2)
		var random_position = sqrt(random_distance) * Vector2(cos(random_angle), sin(random_angle))
		
		var random_item = item_types[rng.randi_range(0, item_types.size() - 1)]
		
		var item_instance = base_item.instantiate()
		item_instance.position = random_position
		item_instance.spawner = self
		item_instance.id = i
		item_instance.item = random_item
		add_child(item_instance)
		
		item_positions.append(random_position)
		is_item_picked_up.append(false)

func register_collected_item(id):
	is_item_picked_up[id] = true
	remaining_items -= 1
	
func are_items_left():
	return remaining_items > 0

# should only be called if there are items left
func get_closest_item_pos(reference_position):
	var closest_item_id = 0
	var closest_item_pos = item_positions[0]
	var closest_item_dist = (reference_position - item_positions[0]).length()
	
	for item_idx in range(len(item_positions)):
		if is_item_picked_up[item_idx]:
			continue
			
		var item_dist = (reference_position - item_positions[item_idx]).length()
		if item_dist < closest_item_dist:
			closest_item_dist = item_dist
			closest_item_pos = item_positions[item_idx]
			closest_item_id = item_idx
		
	return closest_item_pos
	
func restart():
	item_positions = []
	is_item_picked_up = []
	remaining_items = 0
	spawn_items()
