extends Area2D
class_name BaseItem

@onready var sprite = $Sprite2D
var item

# spawner that spawned this item
var spawner
# id within spawner
var id

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if item != null:
		sprite.texture = item.texture
		
func pickup(player):
	queue_free()

func _on_base_item_body_entered(body: Node2D) -> void:
	var player = body as Player
	player.close_item = self
	
func _on_base_item_body_exited(body: Node2D) -> void:
	var player = body as Player
	player.close_item = null
