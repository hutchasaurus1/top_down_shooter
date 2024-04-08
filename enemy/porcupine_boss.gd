extends Enemy

@export var max_health: int = 100
var state = "center"
var height = ProjectSettings.get_setting("display/window/size/viewport_height")
@onready var animation_player = $AnimationPlayer
@onready var health_progress: ProgressBar
@onready var mouth_cannon = $Sprite2D/MouthCannon
@onready var tail_cannon = $Sprite2D/TailCannon
@onready var mouth_cannon_angle_marker = $Sprite2D/MouthCannonAngleMarker
@onready var tail_cannon_angle_marker = $Sprite2D/TailCannonAngleMarker
@onready var back_cannon = $Sprite2D/BackCannon
@onready var back_cannon_angle_marker = $Sprite2D/BackCannonAngleMarker
@onready var fire_rate_timer = $FireRateTimer
@onready var quill_shot = $QuillShot
@onready var destroyed_effect_spawner = $SpawnerComponent
@onready var destruct_nodes = [mouth_cannon, tail_cannon, back_cannon, self, mouth_cannon_angle_marker
	, tail_cannon_angle_marker, back_cannon_angle_marker]


func _ready():
	# Disable the destruction node so we can do custom logic
	destroyed_component.process_mode = Node.PROCESS_MODE_DISABLED
	is_boss = true
	
	super()
	
	# Make the boss invincible until it is centered
	hurtbox_component.is_invincible = true
	stats_component.health = max_health
	
	# Set and display health bar
	var health_nodes = get_tree().get_nodes_in_group("health")
	for node in health_nodes:
		node.visible = true
		if node.name == "BossHealthProgress":
			health_progress = node
			health_progress.value = stats_component.health
			health_progress.max_value = max_health
		if node.name == "BossName":
			node.text = "Space Porcupine"
	
	# Connect to health component to know when we should swap to angry mode
	stats_component.health_changed.connect(func():
		health_progress.value = stats_component.health
		if stats_component.health < max_health / 2 and state == "spin_and_shoot":
			get_angry()
	)
	
	fire_rate_timer.timeout.connect(func():
		if state in ["spin_and_shoot","angry"]:
			fire_quills()
	)
	
	stats_component.no_health.connect(destroy)


func spin_and_shoot(delta):
	hurtbox_component.is_invincible = false
	state = "spin_and_shoot"
	animation_player.play("spin")

	
func fire_quills():
	var cannons = [mouth_cannon, tail_cannon]
	var cannon_markers = [mouth_cannon_angle_marker, tail_cannon_angle_marker]
	if state == "angry":
		cannons.append(back_cannon)
		cannon_markers.append(back_cannon_angle_marker)
	for i in range(len(cannons)):
		var angle = cannons[i].get_angle_to(cannon_markers[i].position)
		quill_shot.spawn(cannons[i].global_position, get_tree().current_scene, angle)


func get_angry():
	state = "angry"
	animation_player.play("angry_spin")
	
# This function returns true if the node's position is past the halfway point of the viewport
func is_past_halfway_point() -> bool:
	var viewport_rect = get_viewport_rect()
	var viewport_center = viewport_rect.size / 2

	# Check if the node's position is past the viewport's horizontal center
	if position.y >= viewport_center.y:
		return true

	return false
	
func _process(delta):
	# Check if the node has moved past the halfway point
	if is_past_halfway_point() and state == "center":
		move_component.velocity = Vector2(0,0)
		state = "spin_and_shoot"
		#spin_and_shoot()
	elif state == "spin_and_shoot":
		spin_and_shoot(delta)
		
func destroy():
	state = "destroy"
	animation_player.play("angry")
	for node in destruct_nodes:
		destroyed_effect_spawner.spawn(node.global_position)
	await get_tree().create_timer(.5).timeout
	get_tree().change_scene_to_file.bind("res://Menus/stage_over.tscn").call_deferred()
	

