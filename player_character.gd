extends CharacterBody3D
class_name PlayerCharacter

@export var SPEED = 5.0
@export var LERP_SPEED = 0.35
@export var JUMP_VELOCITY = 4.5
@export var INVINCIBLE : bool = false

@onready var animTree = $SkinnedMesh/AnimationTree
@onready var stateMachine = $StateMachine
# our wall grab raycast node
@onready var wall_grab_ray : RayCast3D = $WallGrabRayCast3D

func _ready():
	stateMachine.TransitionTo("Locomote")

func _process(delta):
	pass

func _physics_process(delta):
	move_and_slide()
	
	if Input.is_action_just_pressed("click"):
		if wall_grab_ray.is_colliding():
			var collider = wall_grab_ray.get_collider()
			if is_instance_valid(collider):
				if(collider.has_method("get_hit")):
					collider.get_hit(-global_transform.basis.z, global_transform.origin + Vector3(0, 0.5, 0), 1)

	

# called when we receive a hurt from somewhere
func hurt(amount:int, origin:Vector3, impulseMultiplier:int = 50):
	# only if we're not invincible
	if INVINCIBLE:
		return
	else:
		INVINCIBLE = true

	# stop all movement
	velocity = Vector3.ZERO

	# play hurt animation
	animTree.set("parameters/BlendSpace1D/blend_position", 0.0)
	# animTree.set("parameters/Hit", true)
	# animTree.set("parameters/Hit", false)

	print("hurt for " + str(amount) + " damage")
	
	# get the vector from the source to us
	var attackVector = global_transform.origin - origin
	# normalize it
	var normalizedAttackVector = attackVector.normalized()
	normalizedAttackVector.y = 0
	# apply impulse to player character
	velocity = normalizedAttackVector * impulseMultiplier

	# flash the players visibility
	for n in 20:
		visible = !visible
		await get_tree().create_timer(0.05).timeout
	
	INVINCIBLE = false

# a lot of states will need to check for grabbing walls
func check_grab_wall():
	# only if we are facing in the global negative z
	if(global_transform.basis.z.z > 0.9):
		# if the WallGrabRayCast3D note intersects with a wall, grab the wall
		if(wall_grab_ray.is_colliding()):
			var collider = wall_grab_ray.get_collider()
			if is_instance_valid(collider):
				grab_wall()

func grab_wall():
	stateMachine.TransitionTo("Climbing")
