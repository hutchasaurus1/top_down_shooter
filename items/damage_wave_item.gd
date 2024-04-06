extends Item


func _ready():
	super()
	item_name = "damage_wave_item"
	hurtbox_component.hurt.connect(func(hitbox: HitboxComponent):
		queue_free()
	)
