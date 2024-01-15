extends Area2D

var target : Enemy = null
var damage : float = 0.0
var type : Enemy.EnemyType = Enemy.EnemyType.PHYSICAL
var heightOverTime : float = 0.0
var travelTimeTotal : float = 0.0
var travelTime : float = 0.0
var startPos : Vector2 = Vector2.ZERO
var pierceCount : int = 0
var impactEffectScene = null

# Called when the node enters the scene tree for the first time.
func _ready():
	startPos = global_position
	travelTimeTotal = 0.2 + \
		(target.global_position - global_position).length() * 0.001

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if target == null:
		queue_free()
		return
	
	travelTime = min(travelTime + delta, travelTimeTotal)
	var t : float = travelTime / travelTimeTotal
	global_position = lerp(startPos, target.global_position, t);
	var apex : float = abs(t - 0.5) * 2;
	global_position.y  -= (1 - apex * apex) * (10 + travelTimeTotal);

	look_at(target.global_position)


func _on_body_entered(body):
	if body is Enemy:
		var targets = $HitArea.get_overlapping_bodies()
		for target in targets:
			if target is Enemy:
				target.inflict_damage(damage, type)
			
				# Effect if present
				if impactEffectScene != null:
					var impactEffect = impactEffectScene.instantiate()
					impactEffect.global_position = target.global_position
					get_tree().get_root().add_child(impactEffect)
			
		queue_free()
