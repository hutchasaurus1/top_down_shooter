extends ParallaxBackground

@onready var space_layer = %SpaceLayer
@onready var far_stars_layer = %FarStarsLayer
@onready var near_stars_layer = %NearStarsLayer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	space_layer.motion_offset.y += 30 * delta
	far_stars_layer.motion_offset.y += 20 * delta
	near_stars_layer.motion_offset.y += 40 * delta
