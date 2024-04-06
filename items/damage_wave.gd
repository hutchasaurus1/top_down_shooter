extends Node2D

@onready var animation_player = $AnimationPlayer
@export var power: int = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player.play("expansion")
	animation_player.animation_finished.connect(func(anim_name):
		queue_free()
	)

