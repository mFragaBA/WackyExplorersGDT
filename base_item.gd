extends Area2D
class_name BaseItem

@onready var sprite_animation = $AnimatedSprite2D
@export var item : Item

# spawner that spawned this item
var spawner
# id within spawner
var id

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if item != null:
		sprite_animation.sprite_frames = item.sprite_frames
		$AnimatedSprite2D.play("default")
		
func pickup(player):
	queue_free()
	if item != null:
		item.pickup(player)

func _on_base_item_body_entered(body: Node2D) -> void:
	var player = body as Player
	player.close_item = self
	
func _on_base_item_body_exited(body: Node2D) -> void:
	var player = body as Player
	player.close_item = null
