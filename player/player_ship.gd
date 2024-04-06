extends Node2D

@onready var left_muzzle = $LeftMuzzle
@onready var right_muzzle = $RightMuzzle
@onready var spawner_component = $SpawnerComponent
@onready var fire_rate_timer = $FireRateTimer
@onready var scale_component = $ScaleComponent
@onready var animated_sprite_2d = $Anchor/AnimatedSprite2D
@onready var move_component = $MoveComponent
@onready var thrusters = $Anchor/Thrusters
@onready var variable_pitch_audio_stream_player = $VariablePitchAudioStreamPlayer
@onready var fire_rate_item = preload("res://items/fire_rate_item.tscn")
@onready var damage_wave_spawner = $DamageWaveSpawner

@export var game_stats: GameStats

signal item_picked_up(duration: int)

# Called when the node enters the scene tree for the first time.
func _ready():
	fire_rate_timer.timeout.connect(fire_lasers)

func fire_lasers():
	variable_pitch_audio_stream_player.play_with_variance()
	spawner_component.spawn(left_muzzle.global_position)
	spawner_component.spawn(right_muzzle.global_position)
	scale_component.tween_scale()
	
func _process(delta):
	animate_ship()
	
func animate_ship():
	if move_component.velocity.x < 0:
		animated_sprite_2d.play("bank_left")
		thrusters.play("bank_left")
	elif move_component.velocity.x > 0:
		animated_sprite_2d.play("bank_right")
		thrusters.play("bank_right")
	else:
		animated_sprite_2d.play("center")
		thrusters.play("center")


func _on_hitbox_component_hit_hurtbox(hurtbox):
	var item = hurtbox.get_parent()
	if item is Item:
		if item.item_name == "fire_rate_item":
			update_fire_rate(item.fire_rate_modifier, item.duration, item)
		elif item.item_name == "damage_wave_item":
			damage_wave_spawner.spawn(global_position)

func update_fire_rate(fire_rate_modifier: float, duration: int, item: Item):
	fire_rate_timer.wait_time *= 1 / fire_rate_modifier
	emit_signal("item_picked_up", duration)
	await get_tree().create_timer(duration).timeout
	fire_rate_timer.wait_time *= fire_rate_modifier
