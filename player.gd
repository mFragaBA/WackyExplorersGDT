extends CharacterBody2D
class_name Player

var Stat = preload("res://stat.gd")

var speed = Stat.new("SPEED", 300.0)

@onready var item_manager = $"../ItemManager" as ItemManager
@onready var item_indicator_anchor = $ItemIndicatorAnchor
@onready var base_indicator_anchor = $BaseIndicatorAnchor
@onready var base_indicator_sprite = $BaseIndicatorAnchor/Indicator

@onready var score_label = $"../HUD/Control/Score/Label"
var score = 0
var can_do_stuff = true
var is_in_base = true

var focused_item : int = -1
var close_items = []

func _physics_process(delta: float) -> void:
	if !can_do_stuff: return
	
	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_vector("left", "right", "up", "down")
	if direction:
		velocity = direction * speed.get_current_value()
	else:
		var current_speed = speed.get_current_value()
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.y = move_toward(velocity.y, 0, current_speed)

	move_and_slide()

func _input(event: InputEvent) -> void:
	if !can_do_stuff: return
	
	if Input.is_action_just_pressed("pickup") and focused_item != -1:
		var item_to_consume = close_items[focused_item]
		remove_close_item(close_items[focused_item])
		item_to_consume.pickup(self)
		item_manager.register_collected_item(item_to_consume.id)
	elif Input.is_action_just_pressed("pickup") and is_in_base:
		score_points()
		can_do_stuff = false
		
	if Input.is_action_just_pressed("change_focused_item"):
		shift_to_next_focused_item()
		

func _process(delta: float) -> void:
	if item_manager.are_items_left():
		var closest_item_pos = item_manager.get_closest_item_pos(position)
		var direction_towards_item = (position - closest_item_pos).normalized()
		var item_indicator_angle = atan2(direction_towards_item.y, direction_towards_item.x)
		item_indicator_anchor.rotation = item_indicator_angle - PI / 2
		
		var base_pos = Vector2.ZERO
		var direction_towards_base = (position - base_pos).normalized()
		var base_indicator_angle = atan2(direction_towards_base.y, direction_towards_base.x)
		base_indicator_anchor.rotation = base_indicator_angle - PI / 2

func restart() -> void:
	position = Vector2.ZERO
	can_do_stuff = true
	base_indicator_sprite.visible = false
	is_in_base = true
	close_items = []
	focused_item = -1
	
func amount_of_resource_to_consume():
	return 50

func score_points():
	score += 10
	score_label.text = "Score: %s" % score
	
func enter_base(_body):
	is_in_base = true
	base_indicator_sprite.visible = false
	
func exit_base(_body):
	is_in_base = false
	base_indicator_sprite.visible = true

func pickup(item):
	for stat_modifier in item.stat_modifiers_on_pickup:
		if stat_modifier.target_stat_name == speed.name:
			speed.stat_modifiers.append(stat_modifier)

func add_close_item(item):	
	if focused_item != -1:
		close_items[focused_item].set_item_focus(false)
	
	focused_item = close_items.size()
	close_items.append(item)

	item.set_item_focus(true)
	
func remove_close_item(item):
	item.set_item_focus(false)
	
	if focused_item == -1 || close_items.find(item) == -1:
		return		
	
	# If it was the focused one then remove and pick a new one
	# Otherwise just remove, the previouslay focused one should 
	# still be the focused one
	if close_items[focused_item].id == item.id:
		close_items.remove_at(focused_item)
			
		if close_items.size() > 0:
			focused_item = 0
			close_items[0].set_item_focus(true)
		else:
			focused_item = -1
	else:
		var index_of_item = close_items.find(item)
		close_items.erase(item)
		
		if index_of_item < focused_item:
			focused_item -= 1

func shift_to_next_focused_item():
	if focused_item != -1:
		close_items[focused_item].set_item_focus(false)
		focused_item = (focused_item + 1) % close_items.size()
		close_items[focused_item].set_item_focus(true)
