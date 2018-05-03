/datum/modifier/trait
	flags = MODIFIER_GENETIC	// We want traits to persist if the person gets cloned.


/datum/modifier/trait/flimsy
	name = "flimsy"
	desc = "You're more fragile than most, and have less of an ability to endure harm."

	on_created_text = "<span class='warning'>You feel rather weak.</span>"
	on_expired_text = "<span class='notice'>You feel your strength returning to you.</span>"

	max_health_percent = 0.8

/datum/modifier/trait/frail
	name = "frail"
	desc = "Your body is very fragile, and has even less of an ability to endure harm."

	on_created_text = "<span class='warning'>You feel really weak.</span>"
	on_expired_text = "<span class='notice'>You feel your strength returning to you.</span>"

	max_health_percent = 0.6

/datum/modifier/trait/weak
	name = "weak"
	desc = "A lack of physical strength causes a diminshed capability in close quarters combat"

	outgoing_melee_damage_percent = 0.8

/datum/modifier/trait/wimpy
	name = "wimpy"
	desc = "An extreme lack of physical strength causes greatly diminished capability in close quarters combat."

	outgoing_melee_damage_percent = 0.6

/datum/modifier/trait/haemophilia
	name = "haemophilia"
	desc = "You bleed much faster than average."

	bleeding_rate_percent = 3.0

/datum/modifier/trait/inaccurate
	name = "Inaccurate"
	desc = "You're rather inexperienced with guns, you've never used one in your life, or you're just really rusty.  \
	Regardless, you find it quite difficult to land shots where you wanted them to go."

	accuracy = -15
	accuracy_dispersion = 1

/datum/modifier/trait/high_metabolism
	name = "High Metabolsim"
	desc = "Your body's metabolism is faster than average."

	metabolism_percent = 2.0
	incoming_healing_percent = 1.4

/datum/modifier/trait/low_metabolism
	name = "Low Metabolism"
	desc = "Your body's metabolism is slower than average."

	metabolism_percent = 0.5
	incoming_healing_percent = 0.6

/datum/modifier/trait/larger
	name = "Larger"
	desc = "Your body is larger than average."

	icon_scale_percent = 1.1

/datum/modifier/trait/large
	name = "Large"
	desc = "Your body is a bit larger than average."

	icon_scale_percent = 1.05

/datum/modifier/trait/small
	name = "Small"
	desc = "Your body is a bit smaller than average."

	icon_scale_percent = 0.95

/datum/modifier/trait/smaller
	name = "Smaller"
	desc = "Your body is smaller than average."

	icon_scale_percent = 0.9

/datum/modifier/trait/colorblind_taj
	name = "Colorblind - B+R"
	desc = "You are colorblind. You have a minor issue with blue colors and have difficulty recognizing them from red colors."
	
	client_color = MATRIX_Taj_Colorblind

/datum/modifier/trait/colorblind_vulp
	name = "Colorblind - G+R"
	desc = "You are colorblind. You have a severe issue with green colors and have difficulty recognizing them from red colors."
	
	client_color = MATRIX_Vulp_Colorblind

/datum/modifier/trait/colorblind_mono
	name = "Colorblind - Mono"
	desc = "You are colorblind. Your condition is rare, but you can see no colors at all."
	
	client_color = MATRIX_Monochromia
