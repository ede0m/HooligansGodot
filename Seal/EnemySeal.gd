extends KinematicBody

export var min_speed = 12
export var max_speed = 20
var _gravity = Vector3.DOWN * 200
var _speed
var _velocity = Vector3.ZERO
var _crashing = false
var _crash_slowdown_sec
var _crashing_time = 0
var _crash_rotation_speed
	
func _ready():
	randomize()
	
func _physics_process(delta):
	#var velocity = transform.basis.z
	_velocity = _velocity.normalized() * _speed
	_velocity += _gravity * delta
	_velocity = move_and_slide(_velocity, Vector3.UP, false, 4, PI/4, false)
	for index in get_slide_count():
		var collision = get_slide_collision(index)
		if collision.collider.is_in_group("ice") || collision.collider.is_in_group("seal"):
			_crash(collision)
			
	if _crashing:
		_crashing_time += delta
		_speed = lerp(_speed, 0, _crashing_time/_crash_slowdown_sec)
		_crash_rotation_speed = lerp(_crash_rotation_speed, 0, _crashing_time/_crash_slowdown_sec)
		rotate_y(_crash_rotation_speed * delta)
		if _crashing_time >= _crash_slowdown_sec:
			_crashing = false
			queue_free()
	
	
func _crash(collision):
	$Seal/AnimationPlayer.play("Crash")
	var collider = collision.collider
	if collider.is_in_group("ice"):
		collider.crash(-collision.normal*2.5)
	_crashing = true
	_crash_slowdown_sec = _speed/4
	_crash_rotation_speed = _speed/3
	

func initalize(start_pos, target): 
	look_at_from_position(start_pos, target, Vector3.UP)
	#OpenGL means -z is forward, and the seal model doesn't follow this so we rotate another 180deg 
	rotate_object_local(Vector3.UP, PI) 
	_speed = rand_range(min_speed, max_speed)
	_velocity = transform.basis.z
	$Seal/AnimationPlayer.playback_speed = _speed/max_speed*1.5
	$Seal/AnimationPlayer.play("Slide")


func _on_VisibilityNotifier_screen_exited():
	queue_free()
