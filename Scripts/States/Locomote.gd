extends State
class_name Locomote

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@export var mass = 10.0

@export var SPEED = 8
@export var LERP_SPEED = 0.35
	
func Enter(extra_data = null):
	stateMachine.travel("Locomote")

func Exit():
	pass


func Update(_delta: float):
	pass


func Physics_Update(_delta: float):
	# Add the gravity.
	if not playerCharacter.is_on_floor():
		playerCharacter.velocity.y -= gravity * _delta * mass
		playerCharacter.check_grab_wall()
	
	# if the player presses crouch, crouch
	if Input.is_action_just_pressed('crouch'):
		Transitioned.emit('Crouching')
		return
	
	# if the player presses jump, jump
	if Input.is_action_just_pressed("jump"):
		jump()

	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("walk_west", "walk_east", "walk_north", "walk_south")
	
	if input_dir:
		playerCharacter.velocity.x = lerp(playerCharacter.velocity.x, input_dir.x * SPEED, LERP_SPEED)
		playerCharacter.velocity.z = lerp(playerCharacter.velocity.z, input_dir.y * SPEED, LERP_SPEED)
		
		# rotate to face direction
		## add the direction to the current position
		var lookat_location = playerCharacter.global_transform.origin + Vector3(input_dir.x, 0, input_dir.y)
		## lookat that location
		playerCharacter.look_at(lookat_location, Vector3.UP)
	else:
		playerCharacter.velocity.x = lerp(playerCharacter.velocity.x, 0.0, LERP_SPEED)
		playerCharacter.velocity.z = lerp(playerCharacter.velocity.z, 0.0, LERP_SPEED)
	
	animTree.set("parameters/StateMachine/Locomote/blend_position", playerCharacter.velocity.length() / SPEED)
	
	
	for i in playerCharacter.get_slide_collision_count():
		var collider = playerCharacter.get_slide_collision(i).get_collider()
		if(collider.has_method('push')):
			# only if we are pushing towards a cardinal direction (no diagonals)
			var input = Input.get_vector("walk_west", "walk_east", "walk_north", "walk_south").round()
			# one of the values in the vector must be zero
			if input.x == 0 or input.y == 0 and input != Vector2.ZERO:
				get_parent().TransitionTo("LeaningCrate", collider)

func jump():
	Transitioned.emit("Jumping")

