extends Enemy

@onready var states = $States
@onready var move_down_state = %MoveDownState
@onready var move_side_state = %MoveSideState
@onready var pause_state = %PauseState
@onready var move_side_component = %MoveSideComponent
@onready var fire_state = %FireState
@onready var fire_spawner = %FireSpawner
@onready var item_spawner = $ItemSpawner
@onready var utils = preload("res://utilities/utils.gd").new()
@onready var items = ["none", "damage_wave", "fire_rate"]
@onready var item_probabilities = [0.5, 0.1, 0.4]


# Called when the node enters the scene tree for the first time.
func _ready():
	super()
	
	for state in states.get_children():
		state.disable()
		
	move_side_component.velocity.x = [-20,20].pick_random()
	
	move_down_state.state_finished.connect(move_side_state.enable)
	move_side_state.state_finished.connect(func():
		fire_state.enable()
		scale_component.tween_scale()
		fire_spawner.spawn(global_position)
		fire_state.disable()
		fire_state.state_finished.emit()
	)
	fire_state.state_finished.connect(pause_state.enable)
	pause_state.state_finished.connect(move_down_state.enable)
	
	move_down_state.enable()
	assign_item()
	
func assign_item():
	var ind = utils.weighted_selection(item_probabilities)
	var item = items[ind]
	
	if item == "none":
		return
	elif item == "damage_wave":
		item_spawner.scene = load("res://items/damage_wave_item.tscn")
	elif item == "fire_rate":
		item_spawner.scene = load("res://items/fire_rate_item.tscn")
		

