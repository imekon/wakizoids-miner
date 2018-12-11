extends KinematicBody2D

enum STATUS { IDLE, STOP, SLEEPING, TURNING, MOVING, TURN_TO_SHOOT, SHOOTING }

const MOVEMENT = 200.0
const SLEEP_TIME = 3000

onready var label_node = $Node2D
onready var label = $Node2D/Label
onready var firing_position = $FiringPosition
onready var proximity_position = $ProximityPosition

onready var Bullet = load("res://scenes/Bullet.tscn")
onready var TargetingHelper = load("res://scripts/TargetingHelper.gd")

var status
var shields = 100
var thrust
var last_distance
var last_fired
var last_stop
var limit_stop
var targeting_helper
var firing_count

var id setget set_id

signal mining_ship_killed

func _ready():
	targeting_helper = TargetingHelper.new()
	status = IDLE
	thrust = 0
	last_fired = 0
	var angle = randf() * 360
	rotate(deg2rad(angle))

func _process(delta):
	label_node.global_rotation = 0
	
func _physics_process(delta):
	match status:
		IDLE:
			process_idle(delta)
			# label.text = "IDLE"
		STOP:
			process_stop(delta)
			# label.text = "STOP"
		SLEEPING:
			process_sleeping(delta)
			# label.text = "SLEEPING"
		TURNING:
			process_turning(delta)
			# label.text = "TURNING"
		MOVING:
			if !process_proximity():
				process_moving(delta)
				# label.text = "MOVING"
		TURN_TO_SHOOT:
			process_turn_to_shoot(delta)
			# label.text = "SHOOT"
		SHOOTING:
			process_shooting(delta)
			# label.text = "SHOOTING"
	
func set_id(value):
	label.text = "Mining Ship: %d" % value
	
func damage(amount):
	shields -= amount
	if shields < 0:
		emit_signal("mining_ship_killed")
		queue_free()
	
func process_proximity():
	var space = get_world_2d().direct_space_state
	var result = space.intersect_ray(global_position, proximity_position.global_position, [self])
	if result:
		if targeting_helper.is_target(result.collider):
			return false
			
		last_stop = OS.get_ticks_msec()
		limit_stop = Globals.random_range2(1000, 3000)
		status = STOP
		return true
		
	return false
	
func process_idle(delta):
	targeting_helper.clear()
	
	var rocks = get_tree().get_nodes_in_group("rocks")
	var closest_rock = null
	var closest_dist = 1000000
	var closest_position
	for rock in rocks:
		var pos = rock.global_position
		var dist = global_position.distance_to(pos)
		if dist < closest_dist && !rock.is_queued_for_deletion():
			closest_dist = dist
			closest_rock = rock
			closest_position = pos
				
	if closest_rock == null:
		status = SLEEPING
		return
		
	targeting_helper.set_target(closest_rock)
	targeting_helper.plot_course_to_target(closest_position)
	
	status = TURNING
	
func process_stop(delta):
	var now = OS.get_ticks_msec()
	if now - last_stop > limit_stop:
		status = MOVING
	
func process_sleeping(delta):
	var now = OS.get_ticks_msec()
	if now - last_fired > SLEEP_TIME:
		status = IDLE
	
func process_turning(delta):
	if !targeting_helper.plot_course_to_target(global_position):
		return
		
	var angle = rotation_degrees
	var angle_delta
	
	if targeting_helper.target_angle > angle:
		angle_delta = 1
	else:
		angle_delta = -1
		
	if abs(angle - targeting_helper.target_angle) > 1:
		rotate(deg2rad(angle_delta))
	else:
		status = MOVING
	
func process_moving(delta):
	if !targeting_helper.plot_course_to_target(global_position):
		return
		
	thrust = MOVEMENT * delta
	rotation_degrees = targeting_helper.target_angle
	var direction = Vector2(thrust, 0).rotated(deg2rad(targeting_helper.target_angle))
	var collide = move_and_collide(direction)
	
	var distance = position.distance_to(targeting_helper.target_position)
	last_distance = distance
	if distance < 500:
		firing_count = 0
		status = TURN_TO_SHOOT
	
func process_turn_to_shoot(delta):
	if !targeting_helper.plot_course_to_target(global_position):
		return

	var angle = rotation_degrees
	var angle_delta
	
	if targeting_helper.target_angle > angle:
		angle_delta = 1
	else:
		angle_delta = -1
		
	var offset = abs(angle - targeting_helper.target_angle)
		
	if offset > 1:
		rotate(deg2rad(angle_delta))
	else:
		firing_count = 0
		status = SHOOTING
	
func process_shooting(delta):
	var now = OS.get_ticks_msec()
	if now - last_fired > 100:
		var bullet = Bullet.instance()
		bullet.position = firing_position.global_position
		bullet.rotate(rotation)
		get_parent().add_child(bullet)
		last_fired = now
		firing_count += 1

	if firing_count > 5:
		status = SLEEPING
		targeting_helper.clear()

