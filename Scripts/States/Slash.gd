extends State
class_name Slash

func Enter(extra_data = null):
	animTree.set("parameters/AnimSpeed/scale", 4.0)
	stateMachine.travel("Slash")


func Exit():
	animTree.set("parameters/AnimSpeed/scale", 1.0)


func Update(_delta: float):
	playerCharacter.velocity = Vector3.ZERO


func Physics_Update(_delta: float):
	pass

# called from an animation call method track
func finish_slashing():
	print('finisj_slasdjlhaslk')
	Transitioned.emit("Locomote")
