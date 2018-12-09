extends RigidBody2D

const ACCELERATION = 150

export var credits = 30
export var khi_offset = 0.0

func _ready():
	add_to_group("rocks")
	var angle = randf() * 360.0
	apply_impulse(Vector2(), Vector2(0, -ACCELERATION).rotated(deg2rad(angle)))

func on_body_entered(body):
	if body.is_in_group("bullet"):
		Globals.credits += credits
		Globals.khi += khi_offset
		body.queue_free()
		queue_free()
