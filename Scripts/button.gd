extends TextureButton

@onready var upgradeHoverInfo: Node2D = $"../../UpgradeHoverInfo"
@onready var descriptionLabel: RichTextLabel = $"../../UpgradeHoverInfo/DescriptionLabel"

var description : String = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_button_down() -> void:
	scale.x = 0.9
	scale.y = 0.9

func _on_button_up() -> void:
	scale.x = 1
	scale.y = 1

func _on_mouse_entered() -> void:
	if description.length() > 0:
		descriptionLabel.text = description
		upgradeHoverInfo.visible = true;

func _on_mouse_exited() -> void:
	upgradeHoverInfo.visible = false;
