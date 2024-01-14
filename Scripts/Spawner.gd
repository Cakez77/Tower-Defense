extends Node2D

var ghost = preload("res://Scenes/enemy_ghost.tscn")
var timer = 0.0
var gameTime = 0.0

var spawns = [
	{
		"start": 0.0,
		"end": 60.0,
		"batchCount": 1,
		"timer": 0.0,
		"frequency": 2,
		"scene": preload("res://Scenes/enemy_ghost.tscn"),
		"type" : Enemy.EnemyType.MAGIC,
		"speed" : 5.0,
		"health" : 100.0,
		"attack" : 10.0,
		"attackFrame" : 3
	},
	{
		"start": 30.0,
		"end": 120.0,
		"batchCount": 2,
		"timer": 0.0,
		"frequency": 2,
		"scene": preload("res://Scenes/enemy_ghost.tscn"),
		"type" : Enemy.EnemyType.MAGIC,
		"speed" : 50.0,
		"health" : 100.0,
		"attack" : 10.0,
		"attackFrame" : 3
	}
]

var spawnLocations : Array[Vector2] = [
	Vector2(-320,    0),
	Vector2( 320,    0),
	Vector2(   0,  180),
	Vector2(   0, -180)
]

var batchLocations : Array[Vector2] = [
	Vector2(   0,   0),
	Vector2(  -5,   0),
	Vector2(   0,   5),
	Vector2(   5,   0),
	Vector2(   0,  -5)
]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	gameTime += delta;
	
	for spawn in spawns:
		if spawn.start <= gameTime and spawn.end >= gameTime:
			spawn.timer += delta
			while spawn.timer > spawn.frequency:
				var spawnPos = get_viewport_rect().size / 2 + spawnLocations.pick_random()
				for i in range(spawn.batchCount):
					var instance = spawn.scene.instantiate()
					instance.type = spawn.type
					instance.speed = spawn.speed 
					instance.health = spawn.health
					instance.attack = spawn.attack
					instance.attackFrame = spawn.attackFrame
					instance.global_position = spawnPos + batchLocations[i]
					add_child(instance)
				
				spawn.timer -= spawn.frequency
