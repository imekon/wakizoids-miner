extends Node2D

func on_start_pressed():
	get_tree().change_scene("res://scenes/Main.tscn")

func on_about_pressed():
	get_tree().change_scene("res://scenes/About.tscn")
