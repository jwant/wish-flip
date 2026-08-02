extends Node3D

@onready var _camera := %CameraRig as Node3D
@onready var _camera_pivot := %CameraPivot as Node3D
@onready var _ball := %Ball as RigidBody3D

func _process(_delta):
	if not _settle_ball():
		return
	_handle_camera_follow()

func _physics_process(_delta):
	if settled > 0:
		return

	_move_ball()

## Settle Ball ##
var settled = 2.0
func _settle_ball():
	var ball_position = _ball.global_position
	settled -= get_process_delta_time()
	if settled > 0:
		_camera.look_at(ball_position + Vector3(0, 1, 0))
		return false
	return true

## Camera ##
func _handle_camera_follow():
	var delta = get_process_delta_time()
	var ball_position = _ball.global_position
	var movement_direction = _ball.linear_velocity.normalized()
	if movement_direction.length() > 0.1:
		var target_position = ball_position - movement_direction * 3 + Vector3(0, 2, 0)
		_camera.global_position = _camera.global_position.lerp(target_position, delta * 3)
	_camera.look_at(ball_position + Vector3(0, 1, 0))

## Handle Movement ##
const MOVE_SPEED = 500

func _move_ball():
	var delta = get_physics_process_delta_time()
	var velocity = Vector3.ZERO

	# Tilts
	var forward = -_camera.global_basis.z
	forward.y = 0
	forward = forward.normalized()
	var right = _camera.global_basis.x
	right.y = 0
	right = right.normalized()
	velocity += right * Input.get_axis("left", "right") * MOVE_SPEED * delta
	velocity += forward * Input.get_axis("down","up") * MOVE_SPEED * delta

	_tilt_camera()
	_ball.apply_force(velocity)

const MAX_TILT = PI / 8
const TILT_SPEED = 10
var camera_tilt_back = 0.0
var camera_tilt_right = 0.0
func _tilt_camera():
	var delta = get_process_delta_time()
	var left_right = Input.get_axis("left","right")
	var up_down = Input.get_axis("down","up")
	_camera_pivot.rotation.x = lerpf(0.0, MAX_TILT * up_down, TILT_SPEED * delta)
	_camera_pivot.rotation.z = lerpf(0.0, MAX_TILT * left_right, TILT_SPEED * delta)
	# _camera_pivot.rotate(Vector3.BACK, camera_tilt_back)
