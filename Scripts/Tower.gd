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
		"arcHeight" = 10.0,
		"targetCount" = 1,
		"area" = $BoulderWeapon,
		"projectileScene" = preload("res://Scenes/boulder.tscn"),
		"impactScene" = preload("res://Scenes/boulder_impact.tscn"),
		"instance" = null,
		"damage" = 100,
		"targetType" = Enemy.EnemyType.PHYSICAL
	},
		{
		"name" = "Fireball",
		"level" = 1,
		"maxLevel" = 1,
		"attackTimer" = 0.5,
		"attackDelay" = 1.0,
		"arcHeight" = 0.0,
		"targetCount" = 1,
		"area" = $BoulderWeapon,
		"projectileScene" = preload("res://Scenes/fireball.tscn"),
		"impactScene" = preload("res://Scenes/fireball_impact.tscn"),
		"instance" = null,
		"damage" = 100,
		"targetType" = Enemy.EnemyType.MAGIC,
		"upgrades" = [
			{
				"damage" = 100,
				"attackDelay" = 2.5,
				"targetCount" = 1,
				"cost" = 0,
				"upgradeText" = "Hurls a ball of fire towards an Enemy. Priorityzes Magic enemies."
			},
			{
				"damage" = 120,
				"attackDelay" = 2.4,
				"targetCount" = 1,
				"cost" = 300,
				"upgradeText" = "Hurls a ball of fire towards an Enemy. Priorityzes Magic enemies."
			},
		]
	}
]
# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
# We know that we are comparing Enemies here, which is why it works
func compare_enemies(a : Node2D, b : Node2D):
	if a.type == b.type:
		return global_position.distance_squared_to(a.global_position) < \
			   global_position.distance_squared_to(b.global_position)
	
	return a.type == targetPriority


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	for weapon in weapons:
		if weapon.area.visible:
			weapon.attackTimer += delta
			
			while weapon.attackTimer >= weapon.attackDelay:
				targetPriority = weapon.targetType
				targets = weapon.area.get_overlapping_bodies()
				targets.sort_custom(compare_enemies)
				
				var targetCount = weapon.targetCount
				
				for target in targets:
					var proj = weapon.projectileScene.instantiate()
					
					var enemy : Enemy = target
					if enemy.type == weapon.targetType:
						#prefered target
						var a = 0
					
					
					proj.damage = weapon.damage
					proj.type = weapon.targetType
					proj.target = enemy
					proj.arcHeight = weapon.arcHeight
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
	

#	return  (a.global_position - global_position).length() > \
#			(b.global_position - global_position).length()

func _on_first_attack_area_body_entered(_body):
	pass






