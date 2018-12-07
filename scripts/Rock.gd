extends RigidBody2D

const ACCELERATION = 150

export var credits = 30

func _ready():
	add_to_group("rocks")
	var angle = randf() * 360.0
	apply_impulse(Vector2(), Vector2(0, -ACCELERATION).rotated(deg2rad(angle)))

func on_body_entered(body):
	print("body entered rock")
	if body.is_in_group("bullet"):
		print("bullet hits rock")
		Globals.credits += credits
		body.queue_free()
		queue_free()
