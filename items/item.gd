class_name Item

extends Node2D

@onready var flash_component = $FlashComponent
@onready var scale_component = $ScaleComponent
@onready var move_component = $MoveComponent
@onready var visible_on_screen_notifier_2d = $VisibleOnScreenNotifier2D
@onready var hurtbox_component = $HurtboxComponent
@onready var item_name = "none"
@export var game_stats: GameStats
@export var duration: float = 5.0  # Duration of the power-up in seconds

func _ready():
	scale_component.tween_scale()
	flash_component.flash()
	
	visible_on_screen_notifier_2d.screen_exited.connect(queue_free)


