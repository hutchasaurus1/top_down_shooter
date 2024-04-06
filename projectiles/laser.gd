extends Node2D

@onready var visible_on_screen_enabler_2d = $VisibleOnScreenEnabler2D
@onready var scale_component = $ScaleComponent
@onready var flash_component = $FlashComponent
@onready var hitbox_component = $HitboxComponent

# Called when the node enters the scene tree for the first time.
func _ready():
	flash_component.flash()
	scale_component.tween_scale()
	visible_on_screen_enabler_2d.screen_exited.connect(queue_free)
	hitbox_component.hit_hurtbox.connect(func(hurtbox: HurtboxComponent):
		queue_free()
	)
