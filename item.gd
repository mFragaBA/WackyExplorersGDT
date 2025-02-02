extends Resource
class_name Item

@export var stat_modifiers_on_pickup : Array[StatModifier]
@export var points_for_pickup: float
@export var sprite_frames : SpriteFrames

func _init():
	pass

func pickup(player):
	player.pickup(self)
