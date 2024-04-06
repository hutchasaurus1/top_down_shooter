extends Control

@onready var player_ship = $"../playerShip"


func _ready():
	# Assuming you have a reference to the other script
	player_ship.item_picked_up.connect(_on_item_picked_up)

func _on_item_picked_up(duration: float):
	# Reset the progress bar
	var timer_circle = load("res://items/item_duration_bar.tscn").instantiate()
	self.add_child(timer_circle)
	timer_circle.setup(duration)


