extends CanvasLayer

signal start_game

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func show_message(text):
	$Message.text = text 
	$Message.show()
	$MessageTimer.start()

# This function is called when the player loses. 
# It will show "Game Over" for 2 seconds, then return 
# to the title screen and, after a brief pause, show the 
# "Start" button.	
func show_game_over():
	show_message("Game over")
	
	# Wait countdown
	yield($MessageTimer, "timeout")
	
	$Message.text = "Dodge the Creeps!"
	$Message.show()
	
	# Make a one-shot timer and wait for it to finish.
	# delay 1 sec before showing "Start" button
	yield(get_tree().create_timer(1), "timeout")
	
	$StartButton.show()
	
func update_score(score):
	$ScoreLabel.text = str(score)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_MessageTimer_timeout():
	$Message.hide()

func _on_StartButton_pressed():
	$StartButton.hide()
	emit_signal("start_game")
