extends Control

class_name ItemDurationBar

@onready var timer: Timer

func _ready():
	timer = $Timer
	timer.timeout.connect(_on_timer_timeout)

func setup(duration: float):
	self.value = 0
	self.max_value = duration
	timer.wait_time = duration
	timer.start()

func _on_timer_timeout():
	# Handle timer expiration
	queue_free()
	
func _process(delta):
	if timer:
		self.value = timer.time_left
