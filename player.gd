extends CharacterBody2D
class_name Player

const SPEED = 300.0
var close_item

@onready var item_spawner = $"../ItemSpawner" as ItemSpawner
@onready var item_indicator_anchor = $ItemIndicatorAnchor
@onready var base_indicator_anchor = $BaseIndicatorAnchor

func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_vector("left", "right", "up", "down")
	if direction:
		velocity = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()

func _input(event: InputEvent) -> void:
	print(self.close_item)
	if Input.is_action_just_pressed("pickup") and close_item != null:
		close_item.pickup(self)
		item_spawner.register_collected_item(close_item.id)

func _process(delta: float) -> void:
	if item_spawner.are_items_left():
		var closest_item_pos = item_spawner.get_closest_item_pos(position)
		var direction_towards_item = (position - closest_item_pos).normalized()
		var item_indicator_angle = atan2(direction_towards_item.y, direction_towards_item.x)
		item_indicator_anchor.rotation = item_indicator_angle - PI / 2
		
		var base_pos = Vector2.ZERO
		var direction_towards_base = (position - base_pos).normalized()
		var base_indicator_angle = atan2(direction_towards_base.y, direction_towards_base.x)
		base_indicator_anchor.rotation = base_indicator_angle - PI / 2
		
		

	
