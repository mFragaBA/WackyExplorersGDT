extends Resource
class_name StatModifier
		
@export var target_stat_name: String
@export var modifier_kind : ModifierKind
@export var modifier : float

enum ModifierKind { CONSTANT }

func _init():
	pass

func apply_modifiers_to_stat(current_value):
	return current_value + modifier
