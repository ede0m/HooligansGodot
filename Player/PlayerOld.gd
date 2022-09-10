extends KinematicBody

export var move_speed = 3
export var rotate_speed = 3
export (PackedScene) var ice_scene

var gravity = Vector3.DOWN * 1000
var throwing = false
#var throw_timer
var ice_load_hand
var loaded_ice

var _animationStateMachine

func _ready():
	ice_load_hand = $"Linux_Penguin/Linux Penguin (Armature)/Skeleton/IceAttachment/Offset"
	_animationStateMachine = $AnimationTree["parameters/playback"]
#	throw_timer = Timer.new()
#	throw_timer.connect("timeout", self, "end_throw")
#	throw_timer.wait_time = 1.3
#	add_child(throw_timer)

func _physics_process(delta):
	var velocity = Vector3.ZERO
	var forward = Input.is_action_pressed("move_forward")
	var backward = Input.is_action_pressed("move_backward")
	var left = Input.is_action_pressed("move_left")
	var right = Input.is_action_pressed("move_right")
	var throw_hold = Input.is_action_pressed("throw")
	if Input.is_action_just_released("throw"):
		throwing = true
		#throw_timer.start()
	var can_move = !throw_hold and !throwing
	
	# forward is the local forward vector
	if forward and can_move:
		velocity += transform.basis.z * move_speed 
	if backward and can_move:
		velocity += -transform.basis.z * move_speed
	if left and can_move:
		rotate_y(rotate_speed * delta)
	if right and can_move:
		rotate_y(-rotate_speed * delta)
	
	velocity += gravity * delta
	velocity = move_and_slide(velocity, Vector3.UP)
	
	if forward or backward or left or right:
		_animationStateMachine.travel("Walk")
	else:
		_animationStateMachine.travel("Idle")
		
	if throw_hold:
		_animationStateMachine.travel("ThrowHold")
		if !loaded_ice:
			load_ice()
	elif throwing:
		_animationStateMachine.travel("Throw")
		throw_ice()
	
func load_ice():
	var ice = ice_scene.instance()
	ice_load_hand.add_child(ice)
	loaded_ice = ice
	
func throw_ice():
	#ice_load_hand.remove_child(loaded_ice)
	var ice = loaded_ice
	ice.transform.origin = ice_load_hand.transform.origin
	var throw_direction = global_transform.basis.z.normalized()
	var throw_impulse = 1000
	ice.throw(throw_direction * throw_impulse)
	
		
func end_throw() -> void:
	print_debug("mwuau")
	throwing = false
