extends State

@onready var rolling_state := %RollingState as State

func physics_process(_delta):
	if Input.is_action_just_released("space"):
		state_machine.transition_to(rolling_state)

	if Input.is_action_just_pressed("up"):
# 	Set the default gravity direction to `Vector3(0, -1, 0)`.
		var gravity_vector = PhysicsServer3D.area_get_param(get_viewport().find_world_3d().space, PhysicsServer3D.AREA_PARAM_GRAVITY_VECTOR)
		gravity_vector.y *= -1
		PhysicsServer3D.area_set_param(get_viewport().find_world_3d().space, PhysicsServer3D.AREA_PARAM_GRAVITY_VECTOR, gravity_vector)
		state_machine.transition_to(rolling_state)


