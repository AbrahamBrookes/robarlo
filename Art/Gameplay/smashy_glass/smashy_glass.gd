extends StaticBody3D

# the smashy_glass class has 5 break models ranging from 0 (not broken at all)
# to 4 (just about to be smashed). Each time we call get_hit() on this class, we
# hide one and show the next, until there are none left at which point we spawn
# our glass break effect and eventually destroy this scene

# our list of meshes in order of damage
var meshes = []

# the current damage level
var damage = 0

# our smash_particles particle effect
var particles = []

# Called when the node enters the scene tree for the first time.
func _ready():
	# get all the meshes in the scene
	for i in range(5):
		var mesh = get_node("glass_square_break_" + str(i))
		meshes.append(mesh)
		var particle = get_node("smash_particles_" + str(i))
		particles.append(particle)
		particle.hide()
		# hide all but the first mesh
		if i > 0:
			mesh.hide()
	
	# set the current mesh to visible
	meshes[damage].show()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# when we get hit, hide the current mesh and show the next one
func get_hit(normal, point, strength):
	print("smashy_glass got hit")
	if damage < meshes.size():
		# hide the old mesh
		meshes[damage].hide()

		# show and play our relevant particle
		particles[damage].global_transform.origin = point
		particles[damage].show()
		particles[damage].emitting = true
		damage += 1
		
		# if we have another mesh to show
		if damage < meshes.size():
			# show it
			meshes[damage].show()
	
	if damage == meshes.size():
		# spawn our glass break effect
		# var glass_break = load("res://glass_break.tscn").instance()
		# get_parent().add_child(glass_break)
		# glass_break.global_transform = global_transform
		# after our despawn timer times out, remove this scene
		$despawn_timer.start()
		
		# disable our collision shape
		$col.disabled = true
	
