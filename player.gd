extends KinematicBody

var movespeed = 5.0
var gravity = 9.8
var jumpforce = 4.5

var minlookangle = -80.0
var maxlookangle = 80.0
var looksens = 10.0

var vel = Vector3()
var mousedelta = Vector2()

onready var camera = $"Camera"
onready var r = $"Camera/RayCast"

var holdsec=0
var interacted=0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	
	vel.x=0
	vel.z=0
	
	var input = Vector2()
	if Input.is_action_pressed("move_forward"):
		input.y -=1
	if Input.is_action_pressed("move_backwards"):
		input.y +=1
	if Input.is_action_pressed("move_left"):
		input.x -=1
	if Input.is_action_pressed("move_right"):
		input.x +=1
		
	input = input.normalized()
	
	var forward = global_transform.basis.z 
	var right = global_transform.basis.x 
	var relativedir = (forward*input.y+right*input.x)
	
	vel.x=relativedir.x*movespeed 
	vel.z=relativedir.z*movespeed
	
	vel.y -= gravity*delta
	
	vel = move_and_slide(vel, Vector3.UP)
	
	if Input.is_action_pressed("jump") and is_on_floor():
		vel.y = jumpforce

func _process(delta):
	
	camera.rotation_degrees.x -= mousedelta.y*looksens*delta
	camera.rotation_degrees.x=clamp(camera.rotation_degrees.x,minlookangle,maxlookangle)
	
	rotation_degrees.y -= mousedelta.x*looksens*delta
	
	mousedelta=Vector2()
	
	if Input.is_action_pressed("interact"):
		var col=r.get_collider()
		if r.is_colliding() and col.is_in_group("interactions") and interacted==0:
			if holdsec>=1:
				get_tree().call_group("gui-signals","alter_pbar",0)
				col.interact()
				holdsec=0
				interacted=1
			else:
				holdsec+=delta
				get_tree().call_group("gui-signals","alter_pbar",holdsec)
				
	else:
		get_tree().call_group("gui-signals","alter_pbar",0)
		holdsec=0
		interacted=0

func _input(event):
	
	if event is InputEventMouseMotion:
		mousedelta=event.relative
	
	


