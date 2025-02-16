extends Label

var seconds: int
var hour: int
var minute: int

func _ready() -> void:
	var time := Time.get_datetime_dict_from_system()
	hour = time["hour"]
	minute = time["minute"]
	seconds = time["second"]
	# Format the label to display two-digit hours and minutes.
	text = str(hour) + ":" + str(minute)

func _process(delta: float) -> void:
	seconds += delta
	# When seconds accumulate to 60 or more, update the time.
	if seconds >= 60:
		var extra_minutes = int(seconds / 60)
		seconds = seconds % 60
		minute += extra_minutes
		
		# Adjust the hour if the minute count goes above 59.
		if minute >= 60:
			var extra_hours = minute / 60
			minute = minute % 60
			hour += extra_hours
			
			# Wrap the hour if it goes beyond 23.
			if hour >= 24:
				hour %= 24
		
		# Update the Label text.
		text = str(hour) + ":" + str(minute)
