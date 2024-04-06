extends Item

var fire_rate_modifier = 2


func _ready():
	super()
	item_name = "fire_rate_item"
	hurtbox_component.hurt.connect(func(hitbox: HitboxComponent):
		queue_free()
	)
