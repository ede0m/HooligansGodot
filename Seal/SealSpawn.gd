extends Area

func _ready():
	randomize()

func getSpawnLocation() -> Vector3:
	var extents = $CollisionShape.shape.extents
	var worldPos = $CollisionShape.global_transform.origin
	var randZ = rand_range(worldPos.z - extents.z, worldPos.z + extents.z)
	var loc = Vector3(worldPos.x, worldPos.y, randZ)
	return loc
