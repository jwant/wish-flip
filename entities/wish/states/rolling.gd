extends State
const MOVE_SPEED = 500

@onready var _ball := %Ball as RigidBody3D
@onready var _camera := %CameraRig as Node3D
@onready var _camera_pivot := %CameraPivot as Node3D

func physics_process(_delta):
	_move_ball()
	_tilt_camera()

func _move_ball():
	var delta = get_physics_process_delta_time()
	var velocity = Vector3.ZERO
	var forward = -_camera.global_basis.z
	forward.y = 0
	forward = forward.normalized()
	var right = _camera.global_basis.x
	right.y = 0
	right = right.normalized()
	velocity += right * Input.get_axis("left", "right") * MOVE_SPEED * delta
	velocity += forward * Input.get_axis("down","up") * MOVE_SPEED * delta
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
