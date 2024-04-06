extends Node2D

@onready var visible_on_screen_notifier_2d = $VisibleOnScreenNotifier2D
@onready var scale_component = $ScaleComponent
@onready var flash_component = $FlashComponent
@onready var hitbox_component = $HitboxComponent
var speed = 0.25

# Called when the node enters the scene tree for the first time.
func _ready():
	flash_component.flash()
	scale_component.tween_scale()
	visible_on_screen_notifier_2d.screen_exited.connect(func():
		queue_free()
	)
	hitbox_component.hit_hurtbox.connect(func(hurtbox: HurtboxComponent):
		queue_free()
	)

func _physics_process(delta):
	global_position += Vector2.RIGHT.rotated(self.rotation)
