# Give the component a class name so it can be instanced as a custom node
class_name StatsComponent
extends Node

# Create the health variable and connect a setter
@onready var already_dead = false
@export var health: int = 1:
	set(value):
		health = value
		
		# Signal out that the health has changed
		health_changed.emit()
		
		# Signal out when health is at 0
		if health <= 0 and !already_dead:
			no_health.emit()
			already_dead = true

# Create our signals for health
signal health_changed() # Emit when the health value has changed
signal no_health() # Emit when there is no health left
