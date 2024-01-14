extends Area2D

var boulderScene = preload("res://Scenes/boulder.tscn")

# All weapons should have these stats
var attackTimer : float = 0.0
var attackDelay : float = 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func spawn_boulder(target : Enemy):
	var boulder = boulderScene.instantiate()
	boulder.target = target
	add_child(boulder)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
