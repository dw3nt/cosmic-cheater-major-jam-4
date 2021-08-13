extends Area2D

signal loot_spawned

const LOOT_SPAWN_OFFSET = Vector2(8, 8)

export(int) var shardCount = 6
export(float) var explodeVelocity = 15
export(float) var explodeRotation = 0.25
export(float) var shardGravity = 30
export(PackedScene) var lootScene

var shardVelocityMap = {}

onready var sprite = $Polygon2D
onready var collider = $CollisionShape2D
onready var animation = $AnimationPlayer
onready var fadeDelayTimer = $FadeDelayTimer


func _ready():
	randomize()
	

func _process(delta):
	for child in shardVelocityMap.keys():
		child.position -= shardVelocityMap[child] * delta * explodeVelocity
		child.rotation -= shardVelocityMap[child].x * delta * explodeRotation
		shardVelocityMap[child].y -= delta * shardGravity
	
	
func explode():
	var points = sprite.polygon
	for i in range(shardCount):
		points.append(Vector2(randi() % 16, randi() % 16))
		
	var deluanayPoints = Geometry.triangulate_delaunay_2d(points)
	
	for index in len(deluanayPoints) / 3:
		var shardPool = PoolVector2Array()
		var center = Vector2.ZERO
		
		for n in range(3):
			shardPool.append(points[deluanayPoints[(index * 3) + n]])
			center += points[deluanayPoints[(index * 3) + n]]
			
		center /= 3
		
		var shard = Polygon2D.new()
		shard.polygon = shardPool
		shard.position = sprite.position
		shard.texture = sprite.texture
		shardVelocityMap[shard] = Vector2(8, 8) - center
		
		add_child(shard)
		
	sprite.color.a = 0
	

func spawnLoot():
	var inst = lootScene.instance()
	inst.position = position + LOOT_SPAWN_OFFSET
	inst.cratePath = self.get_path()
	get_parent().call_deferred("add_child", inst)
	call_deferred("emit_signal", "loot_spawned", inst)


func _on_Crate_body_entered(body):
	body.queue_free()
	explode()
	collider.set_deferred("disabled", true)
	fadeDelayTimer.start()
	
	if lootScene:
		spawnLoot()


func _on_FadeDelayTimer_timeout():
	animation.play("fade_out")
