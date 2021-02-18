extends KinematicBody

var movespeed : float = 5.0
var gravity : float = 9.8
var jumpforce : float = 4.5

var minlookangle : float = -80.0
var maxlookangle : float = 80.0
var looksens : float = 10.0

var vel : Vector3 = Vector3()
var mousedelta : Vector2 = Vector2()

onready var camera : Camera = get_node("Camera")

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

func _input(event):
	
	if event is InputEventMouseMotion:
		mousedelta=event.relative
		
