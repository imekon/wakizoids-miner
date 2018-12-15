extends KinematicBody2D

const MOVEMENT = 700.0

export var energy: float = 500.0
export var shields: int = 100

onready var left_position = $LeftPosition
onready var firing_position = $FiringPosition
onready var right_position = $RightPosition

onready var label_node = $Node2D

onready var Bullet = load("res://scenes/Bullet.tscn")

var thrust = 0.0
var fire_cycle = 0
var last_fired = 0
var cargo = null

signal player_dead

func _process(delta):
	label_node.global_rotation = 0

func _physics_process(delta):
	var angle = 0.0
	
	if Input.is_action_pressed("move_forward"):
		thrust = MOVEMENT * delta
	if Input.is_action_pressed("move_backward"):
		thrust = -MOVEMENT * delta * 0.25
	if Input.is_action_pressed("turn_left"):
		angle = -2
	if Input.is_action_pressed("turn_right"):
		angle = 2
		
	if Input.is_action_pressed("fire"):
		process_fire()
			
	var rot = rotation_degrees

	var direction = Vector2(thrust, 0).rotated(deg2rad(rot))
	move_and_collide(direction)
	
	rotate(deg2rad(angle))

	thrust *= 0.99
	
	if energy < 500:
		energy += 0.1
	else:
		if shields < 100:
			shields += 1
			
	if Globals.credits < 0:
		emit_signal("player_dead")
	
func process_fire():
	var now = OS.get_ticks_msec()
	if now - last_fired > 100:
		if energy > 50:
			var bullet = Bullet.instance()
			match fire_cycle:
				0:
					bullet.position = firing_position.global_position
				1:
					bullet.position = left_position.global_position
				2:
					bullet.position = right_position.global_position

			fire_cycle += 1
			if fire_cycle > 2:
				fire_cycle = 0
			bullet.rotate(rotation)
			get_parent().add_child(bullet)
			last_fired = now

func damage(amount):
	if shields - amount > 0:
		shields -= amount
		return
		
	shields = 0
	var hit = amount - shields
	
	if energy - hit > 0:
		energy -= hit
		return
		
	energy = 0
	emit_signal("player_dead")
	
func killed_by_black_hole():
	emit_signal("player_dead")
	
	