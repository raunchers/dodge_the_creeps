extends CanvasLayer

# Notifies "main" node that the button has been pressed
signal start_game

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

func show_game_over():
	show_message("Game Over")
	
	# Wait until the message timer has count down
	await $MessageTimer.timeout
	
	$Message.text = "Dodge the\nCreeps!"
	$Message.show()
	
	# Make a one-shot timer and wait for it to finish
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()

func update_score(score):
	$ScoreLabel.text = str(score)

func _on_message_timer_timeout():
	$Message.hide()

func _on_start_button_pressed():
	$StartButton.hide()
	# using the start_game signal
	start_game.emit()
