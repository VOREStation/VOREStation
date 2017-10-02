/datum/modifier/frail
	name = "frail"
	desc = "You are more delicate than the average person."

	flags = MODIFIER_GENETIC

	on_created_text = "<span class='warning'>You feel really weak.</span>"
	on_expired_text = "<span class='notice'>You feel your strength returning to you.</span>"

	max_health_percent = 0.9