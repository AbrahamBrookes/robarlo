extends State
class_name Crouch

func Enter(extra_data = null):
	stateMachine.travel("crouch")


func Exit():
	pass


func Update(_delta: float):
	
	# if the player releases crouch, stand up
	if Input.is_action_just_released('crouch'):
		Transitioned.emit('Locomote')
		return
		
	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("walk_west", "walk_east", "walk_north", "walk_south")
	
	# if we are crouching but we have input, go to crawl
	if input_dir.length():
		Transitioned.emit("crawling")


func Physics_Update(_delta: float):
	pass
