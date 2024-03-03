extends Node
class_name StateMachine

@export var initial_state: State

var states : Dictionary = {}
var current_state : State

func _ready():
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.Transitioned.connect(TransitionTo)
	
	if(initial_state):
		initial_state.Enter()
		current_state = initial_state
	
	print(states)

func _process(delta):
	if(current_state):
		current_state.Update(delta)
	
func _physics_process(delta):
	if(current_state):
		current_state.Physics_Update(delta)

func TransitionTo(new_state_name, extra_data = null):
	var new_state = states.get(new_state_name.to_lower())
	if(!new_state):
		return
	
	if(current_state):
		current_state.Exit()
	
	new_state.Enter(extra_data)
	
	current_state = new_state
	
	print("transitioned to " + new_state_name)
