extends Resource
class_name Stat

@export var name : String
@export var base_value: float
# modifiers corresponding to this stat
@export var stat_modifiers: Array[StatModifier]

func _init(stat_name, value):
	name = stat_name
	base_value = value

func get_current_value():
	var current_value = base_value
	for stat_modifier in stat_modifiers:
		current_value = stat_modifier.apply_modifiers_to_stat(current_value)

	return current_value
