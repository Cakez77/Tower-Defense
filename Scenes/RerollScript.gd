extends TextureButton

@onready var tower: Tower = $"../../Tower"
@onready var upgradeHoverInfo: Control = $"../UpgradeHoverInfo"
@onready var nameLabel: RichTextLabel = $"../UpgradeHoverInfo/PanelContainer/MarginContainer/VBoxContainer/NameLabel"
@onready var costLabel: RichTextLabel = $"../UpgradeHoverInfo/PanelContainer/MarginContainer/VBoxContainer/CostLabel"
@onready var descriptionLabel: RichTextLabel = $"../UpgradeHoverInfo/PanelContainer/MarginContainer/VBoxContainer/DescriptionLabel"
@onready var damageLabel: RichTextLabel = $"../UpgradeHoverInfo/PanelContainer/MarginContainer/VBoxContainer/DamageLabel"
@onready var speedLabel: RichTextLabel = $"../UpgradeHoverInfo/PanelContainer/MarginContainer/VBoxContainer/SpeedLabel"

var mouseInside : bool = false

const coin = preload("res://Assets/Sprites/coin.png")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if mouseInside:
		nameLabel.text = "[color=green]Reroll[/color]"
		costLabel.text = "[img]%s[/img] [color=%s]%s[/color]"\
			% [coin.resource_path, "yellow" \
			if tower.gold >= tower.rerollCost else "red", tower.rerollCost]
		descriptionLabel.text = "Reroll all of the Upgrades"
		damageLabel.text = "";
		speedLabel.text = "";
		upgradeHoverInfo.visible = true
