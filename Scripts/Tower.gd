class_name Tower extends StaticBody2D

# Question: Is this dynamic????
var targetPriority : Enemy.EnemyType = Enemy.EnemyType.MAGIC
var targets : Array[Node2D] = []
var attackTimer : float = 0.0
var gold : float = 200.0
var rerollCost : float = 200.0
const rerollDelay : float = 60.0;
var rerollTimer : float = 0.0

const coinSprite = preload("res://Assets/Sprites/coin.png")
@onready var goldLabel: RichTextLabel = $"../CanvasLayer/GoldLabel"
@onready var rerollProgressBar: ProgressBar = $"../CanvasLayer/RerollProgressBar"


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
				"damage" = 200,
				"attackDelay" = 3.5,
				"targetCount" = 1,
				"cost" = 150,
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
				"cost" = 200,
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
			var weapon = weapons[weaponIdx]
			var upgrade = weapon.upgrades[weapon.level]
			textureButton.texture_normal = weapon.upgradeIcon
			textureButton.icon = weapon.upgradeIcon
			textureButton.abilityName = weapon.name
			textureButton.cost = upgrade.cost
			textureButton.description = weapon.description
			textureButton.damage = upgrade.damage
			textureButton.speed = upgrade.attackDelay

	
# We know that we are comparing Enemies here, which is why it works
func compare_enemies(a : Node2D, b : Node2D):
	if a.type == b.type:
		return global_position.distance_squared_to(a.global_position) < \
			   global_position.distance_squared_to(b.global_position)
	
	return a.type == targetPriority


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	rerollTimer += delta;
	if rerollTimer >= rerollDelay:
		rerollTimer-= rerollDelay
		_reroll()
		
	goldLabel.text = "[color=yellow] %d[/color]" % gold
	rerollProgressBar.value = (rerollTimer / rerollDelay) * 100
	
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

func _upgrade_weapon(idx : int) -> bool:
	var weaponIdx = weaponIndices[idx]
	if weaponIdx >= 0:
		var weapon = weapons[weaponIdx]
		var upgrade = weapon.upgrades[weapon.level]
		if upgrade.cost <= gold:
			weapon.level += 1
			weaponIndices[idx] = -1
			gold -= upgrade.cost
			return true
	return false

func _on_texture_button_0_pressed() -> void:
	var textureButton = weaponUpgradeButtons[0]
	if _upgrade_weapon(0):
		textureButton.texture_normal = null
		textureButton.description = ""

func _on_texture_button_1_pressed() -> void:
	var textureButton = weaponUpgradeButtons[1]
	if _upgrade_weapon(1):
		textureButton.texture_normal = null
		textureButton.description = ""

func _on_texture_button_2_pressed() -> void:
	var textureButton = weaponUpgradeButtons[2]
	if _upgrade_weapon(2):
		textureButton.texture_normal = null
		textureButton.description = ""

func _on_texture_button_3_pressed() -> void:
	var textureButton = weaponUpgradeButtons[3]
	if _upgrade_weapon(3):
		textureButton.texture_normal = null
		textureButton.description = ""

func _on_reroll_button_pressed() -> void:
	if rerollCost <= gold:
		rerollTimer = 0.0
		rerollCost += 100.0
		_reroll()
