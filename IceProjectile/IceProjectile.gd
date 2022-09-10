extends RigidBody

var fading = false
var _fade_total_time = 1
var _fade_time = 0
var _ice_material

func _ready():
	var baseMaterial = $MeshInstance.get_active_material(0)
	_ice_material = baseMaterial.duplicate()
	$MeshInstance.material_override = _ice_material
	
func _process(delta):
	if fading:
		_fade_time += delta
		_ice_material.albedo_color.a = lerp(1.0, 0.0, _fade_time/_fade_total_time)
		if _fade_time >= _fade_total_time:
			queue_free()
		
func throw(dir, power):
	apply_impulse(Vector3(0, power/4, 0), dir * power)

func crash(impulse):
	apply_central_impulse(impulse)
	$FadeTimer.start()

func _on_FadeTimer_timeout():
	fading = true
