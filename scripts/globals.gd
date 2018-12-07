extends Node

enum FILTER { FILTER_NONE, FILTER_ALIENS, FILTER_FLEET, FILTER_ROCKS, FILTER_PLANETS }

var credits: int = 0
var khi: float = 0.0

func random_range(value : int):
	return randi() % value - value / 2

func random_range2(low: int, high: int):
	return randi() % (high - low) + low