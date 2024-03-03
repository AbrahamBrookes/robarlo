extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# when a floor is entered, hide all other floors
func on_floor_entered(floor: Floor):
	# loop through all nodes in the 'floors' node and hide them all
	var floors = get_node("floors")
	for i in range(floors.get_child_count()):
		var floor_node = floors.get_child(i)
		if floor_node != floor:
			floor_node.hide()
		else:
			floor_node.show()

	
