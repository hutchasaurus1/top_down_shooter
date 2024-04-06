extends Node2D

@onready var scale_component = $ScaleComponent
@onready var animation_player = $AnimationPlayer
@onready var visible_on_screen_enabler_2d = $anchor/VisibleOnScreenEnabler2D
@onready var hitbox_component = $anchor/HitboxComponent

# Called when the node enters the scene tree for the first time.
func _ready():
	scale_component.tween_scale()
	hitbox_component.hit_hurtbox.connect(queue_free.unbind(1))
	visible_on_screen_enabler_2d.screen_exited.connect(queue_free)


