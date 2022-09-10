extends Spatial

export (PackedScene) var seal_scene
export (PackedScene) var ice_scene

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _on_SealTimer_timeout():
	var seal = seal_scene.instance()
	var spawnLoc = $SealSpawn.getSpawnLocation()
	var target = $SealExit.transform.origin
	seal.initalize(spawnLoc, target)
	add_child(seal)

func _on_Player_ice_thrown(start_pos, start_rotation, power):
	var ice = ice_scene.instance()
	add_child(ice)
	ice.global_transform.origin = start_pos
	ice.scale = Vector3(0.3,0.3,0.3) # not sure why scale is so messed up here...
	ice.rotation = start_rotation
	var throw_direction = $Player.global_transform.basis.z
	ice.throw(throw_direction, power)
