extends Area2D
signal hit # custom signal called "hit"

@export var speed = 400 # The speed of the player (pixels/sec)
var screen_size # size of the game window

func _ready(): # called when a node enters the scene tree
	screen_size = get_viewport_rect().size
	hide()

func _process(delta): # called every frame
	var velocity = Vector2.ZERO # The player's movement vector
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	
	position += velocity * delta # delta = frame length - the amount of time that the previous frame took to complete. Ensures consistent movement across frame rate changes.
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0


func _on_body_entered(body): # Green icon indicates that a signal is attached to the function
	hide() # player disappears after being hit
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true) # Must be deferred as we can't change physics properties on a physics callback.
	
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
