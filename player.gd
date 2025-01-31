extends CharacterBody2D
class_name Player

const SPEED = 300.0
var close_item

@onready var item_manager = $"../ItemManager" as ItemManager
@onready var item_indicator_anchor = $ItemIndicatorAnchor
@onready var base_indicator_anchor = $BaseIndicatorAnchor

@onready var score_label = $"../HUD/Control/Score/Label"
var score = 0
var can_do_stuff = true

func _physics_process(delta: float) -> void:
	if !can_do_stuff: return
	
	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_vector("left", "right", "up", "down")
	if direction:
		velocity = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()

func _input(event: InputEvent) -> void:
	if !can_do_stuff: return
	
	if Input.is_action_just_pressed("pickup") and close_item != null:
		close_item.pickup(self)
		item_manager.register_collected_item(close_item.id)
	elif Input.is_action_just_pressed("pickup") and is_in_base():
		score_points()
		can_do_stuff = false
		

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
	
func amount_of_resource_to_consume():
	return 50
	
func is_in_base():
	return position.x < 100 && position.y < 100

func score_points():
	score += 10
	score_label.text = "Score: %s" % score
