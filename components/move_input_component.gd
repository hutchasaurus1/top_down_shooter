class_name MoveInputComponent
extends Node

@export var move_component: MoveComponent
@export var move_stats: MoveStats

func _input(event):
	var input_axis = Input.get_axis("ui_left", "ui_right")
	var vert_input_axis = Input.get_axis("ui_up", "ui_down")
	move_component.velocity = Vector2(input_axis * move_stats.speed, vert_input_axis * move_stats.speed)
 
