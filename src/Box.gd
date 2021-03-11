extends Node2D

class_name Box

const _triangle_size: float = 15.0

var current_control_system: ControlSystem = ControlSystem.new()
var target_point: float = 350.0
var successful: bool = false

var velocity: float = 0.0
var accel: float = 0.0

func reset():
	velocity = 0.0
	successful = false
	global_position.x = 350.0

func _process(delta):
	update()

func get_control_system_error() -> float:
	return target_point - global_position.x

func _physics_process(delta: float):
	if successful:
		return
	accel = current_control_system.compute_output(get_control_system_error(), delta)
	velocity += accel * delta
	global_position.x += velocity * delta
	if global_position.x > 700.0 - 25.0:
		velocity *= -0.8
		global_position.x = 700.0 - 25.0
	elif global_position.x < 0.0 + 25.0:
		velocity *= -0.8
		global_position.x = 0.0 + 25.0

func _draw():
	var local_target_point := Vector2(target_point - global_position.x, 0)
	var direction_sign: float = -sign(local_target_point.x)
	local_target_point.x += direction_sign * _triangle_size
	draw_line(Vector2(), local_target_point, Color(1, 0, 0), 5.0)
	local_target_point.x -= direction_sign * _triangle_size
	draw_polygon(PoolVector2Array([
		local_target_point,
		local_target_point + Vector2(direction_sign*_triangle_size, _triangle_size),
		local_target_point + Vector2(direction_sign*_triangle_size, -_triangle_size),
	]), [Color(1, 0.2, 0.2)])
