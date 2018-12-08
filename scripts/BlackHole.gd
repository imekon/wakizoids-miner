extends Sprite

func on_body_entered(body):
	# what about the player???
	body.queue_free()
