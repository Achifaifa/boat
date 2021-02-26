extends StaticBody

var activated=0

func _ready():
	randomize()

func interact():
	activated^=1
	
func _physics_process(delta):
	if activated:
		translate(Vector3(randf()-0.5,randf()-0.5,randf()-0.5))
