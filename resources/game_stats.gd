class_name GameStats

extends Resource

@export var score: int = 0:
	set(value):
		score = value
		score_changed.emit(score)

@export var highscore: int = 0

@export var fire_rate_modifier: int = 1
@export var fire_rate: float = 0.4

signal score_changed(score)
