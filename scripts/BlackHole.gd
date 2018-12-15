extends Sprite

func on_body_entered(body):
	if body.is_in_group("player"):
		body.killed_by_black_hole()
	body.queue_free()
