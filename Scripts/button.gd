extends TextureButton

@onready var tower: Tower = $"../../../Tower"
@onready var upgradeHoverInfo: Control = $"../../UpgradeHoverInfo"
@onready var nameLabel: RichTextLabel = $"../../UpgradeHoverInfo/PanelContainer/MarginContainer/VBoxContainer/NameLabel"
@onready var costLabel: RichTextLabel = $"../../UpgradeHoverInfo/PanelContainer/MarginContainer/VBoxContainer/CostLabel"
@onready var descriptionLabel: RichTextLabel = $"../../UpgradeHoverInfo/PanelContainer/MarginContainer/VBoxContainer/DescriptionLabel"
@onready var damageLabel: RichTextLabel = $"../../UpgradeHoverInfo/PanelContainer/MarginContainer/VBoxContainer/DamageLabel"
@onready var speedLabel: RichTextLabel = $"../../UpgradeHoverInfo/PanelContainer/MarginContainer/VBoxContainer/SpeedLabel"
const coin = preload("res://Assets/Sprites/coin.png")
var icon : Resource = null
var abilityName : String = ""
var cost : int = 0
var description : String = ""
var damage : int = 0
var speed : float = 0.0
var mouseInside : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if mouseInside and description.length() > 0:
		nameLabel.text = "[img]%s[/img] [color=green]%s[/color]"\
			% [icon.resource_path, abilityName]
		costLabel.text = "[img]%s[/img] [color=%s]%s[/color]"\
			% [coin.resource_path, "yellow" if tower.gold >= cost else "red", cost]
		descriptionLabel.text = description
		damageLabel.text = "[color=yellow]Damage: %d[/color]" % damage
		speedLabel.text = "[color=yellow]Attack Cooldown: %.1f[/color]" % speed
		upgradeHoverInfo.visible = true

func _on_button_down() -> void:
	scale.x = 0.9
	scale.y = 0.9

func _on_button_up() -> void:
	scale.x = 1
	scale.y = 1

func _on_mouse_entered() -> void:
	mouseInside = true
	
func _on_mouse_exited() -> void:
	mouseInside = false
