extends Area2D

signal hit

export var speed = 400
var power_speed = 1
var screen_size

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	screen_size = get_viewport_rect().size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2() # x,y
	
	# Detect input
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_select"):
		print("i am speed")
		power_speed = 2
	if Input.is_action_just_released("ui_select"):
		print("i am slowing...")
		power_speed = 1
		
	if velocity.length() > 0:
		velocity = (velocity.normalized() * power_speed ) * speed
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
		
	# Docs:
	# The delta parameter in the _process() function refers to 
	# the frame length - the amount of time that the previous frame 
	# took to complete. Using this value ensures that your movement 
	# will remain consistent even if the frame rate changes.
	position += velocity * delta
	
	# clamp() to prevent it from leaving the screen. 
	# Clamping a value means restricting it to a given range.
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	
	if(velocity.x != 0):
		$AnimatedSprite.animation = "walk"
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = velocity.x < 0 # face left
	elif(velocity.y != 0):
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_v = velocity.y > 0


func _on_Player_body_entered(body):
	hide() # Player disappear
	emit_signal("hit")
	
	# disable the player's collision so that we don't trigger
	# the hit signal more than once.
	# Using set_deferred() tells Godot to wait to disable the 
	# shape until it's safe to do so.
	$CollisionShape2D.set_deferred("disabled", true)

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
