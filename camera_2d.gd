extends Camera2D

@onready var player: CharacterBody2D = $"../Player"

@export var SPEED = 150

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position = lerp(position, player.position, SPEED * delta)

func pickup(player):
	print("picked up!")
