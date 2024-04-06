extends Node2D

@onready var player_ship = $playerShip
@onready var score_label = $HBoxContainer/Score


@export var game_stats: GameStats


func _ready():
	update_score_label(game_stats.score)
	game_stats.score_changed.connect(update_score_label)
	

func _on_player_ship_tree_exiting():
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("res://Menus/game_over.tscn")

func update_score_label(new_score: int):
	score_label.text = "Score : " + str(new_score)
