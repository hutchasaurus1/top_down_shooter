class_name Enemy

extends Node2D

@onready var flash_component = $FlashComponent
@onready var scale_component = $ScaleComponent
@onready var move_component = $MoveComponent
@onready var visible_on_screen_notifier_2d = $VisibleOnScreenNotifier2D
@onready var stats_component = $StatsComponent
@onready var shake_component = $ShakeComponent
@onready var hurtbox_component = $HurtboxComponent
@onready var hitbox_component = $HitboxComponent
@onready var destroyed_component = $DestroyedComponent
@onready var score_component = $ScoreComponent
@onready var variable_pitch_audio_stream_player = $VariablePitchAudioStreamPlayer
var is_boss = false

# Called when the node enters the scene tree for the first time.
func _ready():
	stats_component.no_health.connect(func():
		score_component.adjust_score()
	)
	
	visible_on_screen_notifier_2d.screen_exited.connect(queue_free)
	hurtbox_component.hurt.connect(func(hitbox: HitboxComponent):
		variable_pitch_audio_stream_player.play_with_variance()
		scale_component.tween_scale()
		flash_component.flash()
		shake_component.tween_shake()
	)
	if !is_boss:
		stats_component.no_health.connect(queue_free)
	hitbox_component.hit_hurtbox.connect(destroyed_component.destroy.unbind(1))
	
	
