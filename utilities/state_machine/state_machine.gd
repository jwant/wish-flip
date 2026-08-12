## state_machine.gd
class_name StateMachine
extends Node

@export var initial_state: State

var current_state: State

func _ready() -> void:
	var parent_node = get_parent()

	for child in get_children():
		if child is State:
			child.state_machine = self
			child.parent = parent_node

	# Enter the initial state.
	if initial_state:
		current_state = initial_state
		current_state.enter(null)

func _process(delta: float) -> void:
	if current_state:
		current_state.process(delta)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_process(delta)

func transition_to(target_state: State) -> void:
	if target_state == current_state:
		return

	var previous := current_state
	current_state.exit()
	current_state = target_state
	current_state.enter(previous)
