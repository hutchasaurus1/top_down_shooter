extends AudioStreamPlayer

@onready var node = $"."

func _on_finished():
	node.play()
