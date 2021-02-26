extends MarginContainer

onready var progressbar= $"Control/interactbar"

func _ready():
	pass

func alter_pbar(val):
	if val==0:
		progressbar.hide()
	else:
		progressbar.show()
		progressbar.value=val



