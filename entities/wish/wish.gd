extends Node3D

@onready var _camera := %CameraRig as Node3D
@onready var _ball := %Ball as RigidBody3D
@onready var _state_machine := %StateMachine as StateMachine
@onready var activating_state := %ActivatingState as State

func _process(_delta):
	if not _settle_ball():
		return
	_handle_camera_follow()

func _physics_process(_delta):
	if settled > 0:
		return

	_handle_action()

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
		var gravity_vector = PhysicsServer3D.area_get_param(
			get_viewport().find_world_3d().space,
			PhysicsServer3D.AREA_PARAM_GRAVITY_VECTOR
		)

		var gravity_dir = gravity_vector.normalized()
		var camera_up = -gravity_dir
		var forward = movement_direction.slide(gravity_dir)

		if forward.length() > 0.01:
			forward = forward.normalized()
			var right = forward.cross(camera_up).normalized()

			# Camera Follow
			var target_position = (
				ball_position
				- forward * .5
				+ camera_up * 1.5
			)
			_camera.global_position = _camera.global_position.lerp(
				target_position,
				delta * 10
			)

			# Camera Rotation
			var target_basis = Basis(
				right,
				camera_up,
				-forward
			).orthonormalized()
			var current_rotation := _camera.global_basis.get_rotation_quaternion()
			var target_rotation := target_basis.get_rotation_quaternion()
			var rotation_speed := 3
			var new_rotation := current_rotation.slerp(
				target_rotation,
				delta * rotation_speed
			)
			_camera.global_basis = Basis(new_rotation)

## Ball Actions ##
func _handle_action():
	if Input.is_action_just_pressed("space"):
		_state_machine.transition_to(activating_state)
