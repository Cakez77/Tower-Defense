class_name Tower extends StaticBody2D

# Question: Is this dynamic????
var targetPriority : Enemy.EnemyType = Enemy.EnemyType.MAGIC
var targets : Array[Node2D] = []
var attackTimer : float = 0.0

@onready var weaponUpgradesSlots = $"../CanvasLayer/WeaponUpgrades"
@onready var weaponUpgradeButtons = [
	$"../CanvasLayer/WeaponUpgrades/TextureButton0",
	$"../CanvasLayer/WeaponUpgrades/TextureButton1",
	#$"../CanvasLayer/WeaponUpgrades/TextureButton2",
	#$"../CanvasLayer/WeaponUpgrades/TextureButton3"
]

@onready var weapons = [
	{
		"name" = "Boulder",
		"level" = 0,
		"attackTimer" = 0.0,
		"arcHeight" = 10.0,
		"area" = $BoulderWeapon,
		"projectileScene" = preload("res://Scenes/boulder.tscn"),
		"impactScene" = preload("res://Scenes/boulder_impact.tscn"),
		"instance" = null,
		"targetType" = Enemy.EnemyType.PHYSICAL,
		"description" = \
			"Throws a big Boulder towards an Enemy. Priorityzes Armoured enemies.",
		"upgradeIcon" = preload("res://Assets/Sprites/boulder_icon.png"),
		"upgrades" = [
			{
				"damage" = 100,
				"attackDelay" = 2.5,
				"targetCount" = 1,
				"cost" = 0,
			},
			{
				"damage" = 120,
				"attackDelay" = 2.4,
				"targetCount" = 1,
				"cost" = 300,
			},
		]
	},
		{
		"name" = "Fireball",
		"level" = 0,
		"attackTimer" = 0.5,
		"attackDelay" = 1.0,
		"arcHeight" = 0.0,
		"targetCount" = 1,
		"area" = $BoulderWeapon,
		"projectileScene" = preload("res://Scenes/fireball.tscn"),
		"impactScene" = preload("res://Scenes/fireball_impact.tscn"),
		"instance" = null,
		"targetType" = Enemy.EnemyType.MAGIC,
		"description" = \
			"Hurls a ball of fire towards an Enemy. Priorityzes Magic enemies.",	
		"upgradeIcon" = preload("res://Assets/Sprites/fireball_icon.png"),
		"upgrades" = [
			{
				"damage" = 100,
				"attackDelay" = 2.5,
				"targetCount" = 1,
				"cost" = 0,
			},
			{
				"damage" = 120,
				"attackDelay" = 2.4,
				"targetCount" = 1,
				"cost" = 300,
			},
			{
				"damage" = 140,
				"attackDelay" = 2.2,
				"targetCount" = 1,
				"cost" = 600,
			},
		]
	}
]

var weaponIndices : Array[int] = [-1, -1, -1, -1]
# Called when the node enters the scene tree for the first time.
func _ready():
	_reroll()
	
func _reroll():
	for i in weaponIndices.size():
		weaponIndices[i] = -1

	var idxCount = 0
	while idxCount < weapons.size():
		var idx = randi_range(0, weapons.size() - 1)
		if weaponIndices.has(idx):
			continue
		if weapons[idx].level + 1 < weapons[idx].upgrades.size():
			weaponIndices[idxCount] = idx
		idxCount += 1
	
	for i in weaponUpgradeButtons.size():
		var textureButton = weaponUpgradeButtons[i]
		textureButton.texture_normal = null
		textureButton.description = ""
		var weaponIdx = weaponIndices[i]
		if weaponIdx >= 0:
			textureButton.texture_normal = weapons[weaponIdx].upgradeIcon
			var script = textureButton.get_script()
			textureButton.description = weapons[weaponIdx].description

	
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
			var attackDelay = weapon.upgrades[weapon.level].attackDelay
			
			while weapon.attackTimer >= attackDelay:
				targetPriority = weapon.targetType
				targets = weapon.area.get_overlapping_bodies()
				targets.sort_custom(compare_enemies)
				
				var targetCount = weapon.upgrades[weapon.level].targetCount
				
				for target in targets:
					var proj = weapon.projectileScene.instantiate()
					var enemy : Enemy = target
					
					proj.damage = weapon.upgrades[weapon.level].damage
					proj.type = weapon.targetType
					proj.target = enemy
					proj.arcHeight = weapon.arcHeight
					proj.impactEffectScene = weapon.impactScene
					add_child(proj)
					break
				weapon.attackTimer -= attackDelay;
			
	
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

func _on_reroll_timer_timeout() -> void:
	_reroll()
	

func _upgrade_weapon(idx : int):
	var weaponIdx = weaponIndices[idx]
	if weaponIdx >= 0:
		weapons[weaponIdx].level += 1
		weaponIndices[idx] = -1

func _on_texture_button_0_pressed() -> void:
	var textureButton = weaponUpgradeButtons[0]
	textureButton.texture_normal = null
	_upgrade_weapon(0)

func _on_texture_button_1_pressed() -> void:
	var textureButton = weaponUpgradeButtons[1]
	textureButton.texture_normal = null
	_upgrade_weapon(1)

func _on_texture_button_2_pressed() -> void:
	var textureButton = weaponUpgradeButtons[2]
	textureButton.texture_normal = null
	_upgrade_weapon(2)

func _on_texture_button_3_pressed() -> void:
	var textureButton = weaponUpgradeButtons[3]
	textureButton.texture_normal = null
	_upgrade_weapon(3)
