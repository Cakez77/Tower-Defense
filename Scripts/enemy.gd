extends CharacterBody2D

var tower
var speed

# Called when the node enters the scene tree for the first time.
func _ready():
	modulate.a = 0
	speed = 50
	tower = get_tree().get_first_node_in_group("Tower")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	modulate.a = min(1, modulate.a + delta)
	velocity = (tower.global_position - global_position).normalized() * speed
	if velocity.x > 0:
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false

	move_and_slide()
