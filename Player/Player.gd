extends KinematicBody

export var move_speed = 3
export var rotate_speed = 3
export var max_throw_boost = 15
export (PackedScene) var ice_scene

signal ice_thrown(start_pos, start_rotation, power)

var _gravity = Vector3.DOWN * 1000
var _throwing = false
var _thow_boost = 0
var _throw_hold_boost_total_time = 4
var _throw_hold_boost_time = 0
var _ice_load_hand
var _ice
var _loaded_ice = false
var _animation_steat_machine

func _ready():
	_ice_load_hand = $"Linux_Penguin/Linux Penguin (Armature)/Skeleton/IceAttachment/Offset"
	_ice = ice_scene.instance()
	_animation_steat_machine = $AnimationTree["parameters/playback"]

func _physics_process(delta):
	var velocity = Vector3.ZERO
	var forward = Input.is_action_pressed("move_forward")
	var backward = Input.is_action_pressed("move_backward")
	var left = Input.is_action_pressed("move_left")
	var right = Input.is_action_pressed("move_right")
	var throw_hold = Input.is_action_pressed("throw")
	if Input.is_action_just_released("throw"):
		_throwing = true
	var can_move = !throw_hold and !_throwing
	
	# forward is the local forward vector
	if forward and can_move:
		velocity += transform.basis.z * move_speed 
	if backward and can_move:
		velocity += -transform.basis.z * move_speed
	if left and can_move:
		rotate_y(rotate_speed * delta)
	if right and can_move:
		rotate_y(-rotate_speed * delta)
	
	velocity += _gravity * delta
	velocity = move_and_slide(velocity, Vector3.UP)
	
	if forward or backward or left or right:
		_animation_steat_machine.travel("Walk")
	else:
		_animation_steat_machine.travel("Idle")
		
	if throw_hold:
		_throw_hold_boost_time += delta
		_animation_steat_machine.travel("ThrowHold")
		if !_loaded_ice:
			load_ice()
	elif _throwing:
		_animation_steat_machine.travel("Throw")
	
func load_ice():
	_ice_load_hand.add_child(_ice)
	_loaded_ice = true
	
func release_ice() -> void:
	_ice_load_hand.remove_child(_ice)
	_loaded_ice = false
	var base_throw_power = 8
	var boost_power = _throw_hold_boost_time/_throw_hold_boost_total_time * max_throw_boost
	var ice_position = _ice_load_hand.global_transform.origin
	var ice_rotation = _ice_load_hand.global_transform.basis.get_euler()
	emit_signal("ice_thrown", ice_position, ice_rotation, base_throw_power + boost_power)
	_throw_hold_boost_time = 0
	
func end_throw() -> void:
	_throwing = false
