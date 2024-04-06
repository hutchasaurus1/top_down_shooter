extends Node2D

@export var green_enemy_scene: PackedScene
@export var yellow_enemy_scene: PackedScene
@export var pink_enemy_scene: PackedScene
@export var porcupine_scene: PackedScene
@onready var spawner_component = $SpawnerComponent
@onready var green_enemy_spawn_timer = $GreenEnemySpawnTimer
@onready var yellow_enemy_spawn_timer = $YellowEnemySpawnTimer
@onready var pink_enemy_spawn_timer = $PinkEnemySpawnTimer

@export var game_stats: GameStats

var margin = 8
var width = ProjectSettings.get_setting("display/window/size/viewport_width")
var stage: int = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	green_enemy_spawn_timer.timeout.connect(handle_spawn.bind(green_enemy_scene, green_enemy_spawn_timer))
	yellow_enemy_spawn_timer.timeout.connect(handle_spawn.bind(yellow_enemy_scene, yellow_enemy_spawn_timer, 5.0))
	pink_enemy_spawn_timer.timeout.connect(handle_spawn.bind(pink_enemy_scene, pink_enemy_spawn_timer, 6.0))
	if stage == 3:
		enter_porcupine()
		green_enemy_spawn_timer.process_mode = Node.PROCESS_MODE_DISABLED
	
	game_stats.score_changed.connect(func(new_score):
		if stage != 1:
			pass
		elif new_score > 500:
			yellow_enemy_spawn_timer.process_mode = Node.PROCESS_MODE_DISABLED
			green_enemy_spawn_timer.process_mode = Node.PROCESS_MODE_DISABLED
			pink_enemy_spawn_timer.process_mode = Node.PROCESS_MODE_DISABLED
			stage = 2
			stage_2()
		elif new_score > 50:
			pink_enemy_spawn_timer.process_mode = Node.PROCESS_MODE_INHERIT
		elif new_score > 10:
			yellow_enemy_spawn_timer.process_mode = Node.PROCESS_MODE_INHERIT
	)


func handle_spawn(enemy_scene: PackedScene, timer: Timer, time_offset: float = 1.0):
	spawner_component.scene = enemy_scene
	spawner_component.spawn(Vector2(randf_range(margin, width - margin), 0))
	var spawn_rate = time_offset / (0.5 + game_stats.score * 0.01)
	timer.start(spawn_rate + randf_range(0.25, 0.5))
	

func stage_2():
	spawner_component.scene = yellow_enemy_scene
	for i in range(40):
		spawner_component.spawn(Vector2((width - 2 * margin) * (1 + i) / 40, 0))
		await get_tree().create_timer(0.4).timeout
	
	await get_tree().create_timer(10).timeout
	enter_porcupine()
	
func enter_porcupine():
	stage = 3
	spawner_component.scene = porcupine_scene
	spawner_component.spawn(Vector2(width / 2, 0))
