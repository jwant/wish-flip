extends Node3D

@onready var _camera := %CameraRig as Node3D
@onready var _camera_pivot := %CameraPivot as Node3D
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

	var waiting_input = _handle_action()

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


## Ball Actions ##
func _handle_action():
	if Input.is_action_just_pressed("space"):
		_state_machine.transition_to(activating_state)
