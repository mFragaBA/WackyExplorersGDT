extends Node

@onready var item_manager = $"../ItemManager" as ItemManager
@onready var players = [$"../Player"]

@onready var resource_bar = $"../HUD/Control/RemainingResourceBar"
const INITIAL_RESOURCE = 1000
var resource_left = INITIAL_RESOURCE

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	restart()
	resource_bar.max_value = INITIAL_RESOURCE
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# drain base
	resource_left -= 10 * delta
	
	# consume resource for each player
	for player in players:
		resource_left -= player.amount_of_resource_to_consume() * delta
		
	if resource_left <= 0:
		restart()
		
	resource_bar.value = resource_left

func restart() -> void:
	item_manager.restart()
	players[0].restart()
	resource_left = INITIAL_RESOURCE
