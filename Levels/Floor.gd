extends Node3D
class_name Floor

signal floor_entered

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# when told to, emit a signal saying "floor_entered"
func on_floor_entered(body: Node3D):
	emit_signal("floor_entered", self)
