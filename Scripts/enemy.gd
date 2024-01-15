class_name Enemy extends CharacterBody2D

var tower
enum EnemyType {MAGIC, PHYSICAL}
var type : EnemyType
var speed : float
var health : float
var attack : float
var attackFrame : int = 3
var damagedTimer : float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	modulate.a = 0
	speed = 50
	tower = get_tree().get_first_node_in_group("Tower")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if damagedTimer > 0.0:
		damagedTimer = max(damagedTimer - delta, 0.0)
#		modulate = Color(100, 100, 100, 1)
#	else:
#		modulate = Color(1, 1, 1, modulate.a)
	
	if ($AnimatedSprite2D.get_animation() == "Walking"):
		modulate.a = min(1, modulate.a + delta)
		velocity = (tower.global_position - global_position).normalized() * speed
		if velocity.x > 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false

		move_and_slide()
	
func inflict_damage(amount, targetType : Enemy.EnemyType):
	if type == targetType:
		health -= amount
	else:
		health -= amount / 2
		
	if health <= 0:
		$"Spread Out Shape".set_deferred("disabled", true)
		$AnimatedSprite2D.play("Death")
		
	damagedTimer = 0.1

func _on_area_2d_body_entered(body):
	if body is Tower:
		$AnimatedSprite2D.play("Attack")

func _on_area_2d_body_exited(body):
	if body is Tower:
		$AnimatedSprite2D.play("Walking")

func _on_animated_sprite_2d_frame_changed():
	if ($AnimatedSprite2D.get_animation() == "Attack" and
		$AnimatedSprite2D.frame == attackFrame):
		print("attacking tower")

func _on_animated_sprite_2d_animation_finished():
	if ($AnimatedSprite2D.get_animation() == "Death"):
		queue_free()
