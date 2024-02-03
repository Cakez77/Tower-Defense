class_name Enemy extends CharacterBody2D

var tower
enum EnemyType {MAGIC, PHYSICAL}
var type : EnemyType
var speed : float
var health : float
var maxHealth : float
var attack : float
var attackFrame : int = 3
var damagedTimer : float = 0.0

@onready var animatedSprite2D = $AnimatedSprite2D
@onready var spreadOutShape = $"Spread Out Shape"
@onready var hpBarForeground = $HPBarForeground
@onready var hpBarBackground = $HPBarBackground
const floatingNumberScene = preload("res://Scenes/floating_number.tscn")
const floatingGoldScene = preload("res://Scenes/floating_gold.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	modulate.a = 0
	maxHealth = health
	tower = get_tree().get_first_node_in_group("Tower")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if damagedTimer > 0.0:
		damagedTimer = max(damagedTimer - delta, 0.0)
#		modulate = Color(100, 100, 100, 1)
#	else:
#		modulate = Color(1, 1, 1, modulate.a)

	var bgScale = hpBarBackground.scale.x;
	var fgScale = hpBarForeground.scale.x;
	hpBarForeground.scale.x = (health / maxHealth) * hpBarBackground.scale.x
		
	
	if (animatedSprite2D.get_animation() == "Walking"):
		modulate.a = min(1, modulate.a + delta)
		velocity = (tower.global_position - global_position).normalized() * speed
		if velocity.x > 0:
			animatedSprite2D.flip_h = true
		else:
			animatedSprite2D.flip_h = false

		move_and_slide()
	
func inflict_damage(amount, targetType : Enemy.EnemyType):
	var damage = amount;
	if type != targetType:
		damage = damage / 2
		
	health -= damage;
	
	var damageNumber = floatingNumberScene.instantiate()
	damageNumber.global_position = global_position + Vector2(0, -20)
	damageNumber.get_node("Label").text = str(damage)
	get_tree().root.add_child(damageNumber)
		
	if health <= 0:
		spreadOutShape.set_deferred("disabled", true)
		animatedSprite2D.play("Death")
		hpBarBackground.visible = false;
		hpBarForeground.visible = false;
		
		# Gold is (health + speed + attack) * 0.05
		var gold : float = (maxHealth + speed + attack) * 0.05
		var floatingGold = floatingGoldScene.instantiate()
		floatingGold.get_node("RichTextLabel").text = \
			"[img]res://Assets/Sprites/coin_small.png[/img] %d" % gold
		floatingGold.global_position = global_position + Vector2(0, -20)
		get_tree().root.add_child(floatingGold)
		tower.gold += gold
		
		
	damagedTimer = 0.1

func _on_area_2d_body_entered(body):
	if body is Tower:
		animatedSprite2D.play("Attack")

func _on_area_2d_body_exited(body):
	if body is Tower:
		animatedSprite2D.play("Walking")

func _on_animated_sprite_2d_frame_changed():
	if (animatedSprite2D.get_animation() == "Attack" and
		animatedSprite2D.frame == attackFrame):
		print("attacking tower")

func _on_animated_sprite_2d_animation_finished():
	if (animatedSprite2D.get_animation() == "Death"):
		queue_free()
