class_name Tower extends StaticBody2D

# Question: Is this dynamic????
var targetPriority : Enemy.EnemyType = Enemy.EnemyType.MAGIC
var targets : Array[Node2D] = []
var attackTimer : float = 0.0

var boulderWeaponScene = preload("res://Scenes/boulder_weapon.tscn")
var boulderWeapon = null

var weapons = [
	{
		"scene" = preload("res://Scenes/boulder_weapon.tscn")
	}	
]

# Called when the node enters the scene tree for the first time.
func _ready():
	boulderWeapon = boulderWeaponScene.instantiate()
	add_child(boulderWeapon)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	boulderWeapon.attackTimer += delta
	
	while boulderWeapon.attackTimer >= boulderWeapon.attackDelay:
		targets = $FirstAttackArea.get_overlapping_bodies()
		targets.sort_custom(compare_enemies)
		
		for target in targets:
			var enemy : Enemy = target
			boulderWeapon.spawn_boulder(enemy)
			break
		boulderWeapon.attackTimer -= boulderWeapon.attackDelay;
	
# We know that we are comparing Enemies here, which is why it works
func compare_enemies(a : Node2D, b : Node2D):
	return  (a.global_position - global_position).length() > \
			(b.global_position - global_position).length()

func _on_first_attack_area_body_entered(_body):
	pass






