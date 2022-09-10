extends AnimationPlayer


func _ready():
	get_animation("Idle").set_loop(true)
	get_animation("Walk").set_loop(true)
