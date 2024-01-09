extends Node2D

var ghost = preload("res://Scenes/enemy_ghost.tscn")
var timer = 0.0

var spawnLocations : Array[Vector2] = [
	Vector2(-320,    0),
	Vector2( 320,    0),
	Vector2(   0,  180),
	Vector2(   0, -180)
]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer += delta
	
	if timer > 1:
		var instance = ghost.instantiate()
		var position = get_viewport_rect().size / 2 + spawnLocations.pick_random()
		
		instance.global_position = position
		add_child(instance)
		timer -= 1

