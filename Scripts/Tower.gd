class_name Tower extends StaticBody2D

# Question: Is this dynamic????
var targetPriority : Enemy.EnemyType = Enemy.EnemyType.MAGIC
var targets : Array[Node2D] = []
var attackTimer : float = 0.0

@onready var weapons = [
	{
		"name" = "Boulder",
		"level" = 1,
		"maxLevel" = 1,
		"attackTimer" = 0.0,
		"attackDelay" = 1.0,
		"area" = $BoulderWeapon,
		"projectileScene" = preload("res://Scenes/boulder.tscn"),
		"impactScene" = preload("res://Scenes/impact_effect.tscn"),
		"instance" = null,
		"damage" = 200,
		"type" = Enemy.EnemyType.PHYSICAL
	}
]
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	for weapon in weapons:
		if weapon.area.visible:
			weapon.attackTimer += delta
			
			while weapon.attackTimer >= weapon.attackDelay:
				targets = weapon.area.get_overlapping_bodies()
				targets.sort_custom(compare_enemies)
				
				for target in targets:
					var enemy : Enemy = target
					var proj = weapon.projectileScene.instantiate()
					proj.damage = weapon.damage
					proj.type = weapon.type
					proj.target = enemy
					proj.impactEffectScene = weapon.impactScene
					add_child(proj)
					break
				weapon.attackTimer -= weapon.attackDelay;
			
	
#	while boulderWeapon.attackTimer >= boulderWeapon.attackDelay:
#		targets = $FirstAttackArea.get_overlapping_bodies()
#		targets.sort_custom(compare_enemies)
#
#		for target in targets:
#			var enemy : Enemy = target
#			boulderWeapon.spawn_boulder(enemy)
#			break
#		boulderWeapon.attackTimer -= boulderWeapon.attackDelay;
	
# We know that we are comparing Enemies here, which is why it works
func compare_enemies(a : Node2D, b : Node2D):
	return global_position.distance_squared_to(a.global_position) < \
		   global_position.distance_squared_to(b.global_position)
#	return  (a.global_position - global_position).length() > \
#			(b.global_position - global_position).length()

func _on_first_attack_area_body_entered(_body):
	pass






