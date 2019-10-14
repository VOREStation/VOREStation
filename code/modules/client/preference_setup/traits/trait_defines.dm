// This contains character setup datums for traits.
// The actual modifiers (if used) for these are stored inside code/modules/mob/_modifiers/traits.dm

/datum/trait/modifier
	var/modifier_type = null // Type to add to the mob post spawn.

/datum/trait/modifier/apply_trait_post_spawn(mob/living/L)
	L.add_modifier(modifier_type)

/datum/trait/modifier/generate_desc()
	var/new_desc = desc
	if(!modifier_type)
		new_desc = "[new_desc] This trait is not implemented yet."
		return new_desc
	var/datum/modifier/M = new modifier_type()
	if(!desc)
		new_desc = M.desc // Use the modifier's description, if the trait doesn't have one defined.
	var/modifier_effects = M.describe_modifier_effects()
	new_desc = "[new_desc][modifier_effects ? "<br>[modifier_effects]":""]" // Now describe what the trait actually does.
	qdel(M)
	return new_desc


// Physical traits are what they sound like, and involve the character's physical body, as opposed to their mental state.
/datum/trait/modifier/physical
	category = "Physical Quirks" //VOREStation Edit


/datum/trait/modifier/physical/flimsy
	name = "Flimsy"
	desc = "You're more fragile than most, and have less of an ability to endure harm."
	modifier_type = /datum/modifier/trait/flimsy
	mutually_exclusive = list(/datum/trait/modifier/physical/frail)


/datum/trait/modifier/physical/frail
	name = "Frail"
	desc = "Your body is very fragile, and has even less of an ability to endure harm."
	modifier_type = /datum/modifier/trait/frail
	mutually_exclusive = list(/datum/trait/modifier/physical/flimsy)


/datum/trait/modifier/physical/haemophilia
	name = "Haemophilia"
	desc = "Some say that when it rains, it pours.  Unfortunately, this is also true for yourself if you get cut."
	modifier_type = /datum/modifier/trait/haemophilia

/datum/trait/modifier/physical/haemophilia/test_for_invalidity(var/datum/category_item/player_setup_item/traits/setup)
	if(setup.is_FBP())
		return "Full Body Prosthetics cannot bleed."
	// If a species lacking blood is added, it is suggested to add a check for them here.
	return ..()


/datum/trait/modifier/physical/weak
	name = "Weak"
	desc = "A lack of physical strength causes a diminshed capability in close quarters combat."
	modifier_type = /datum/modifier/trait/weak
	mutually_exclusive = list(/datum/trait/modifier/physical/wimpy)


/datum/trait/modifier/physical/wimpy
	name = "Wimpy"
	desc = "An extreme lack of physical strength causes a greatly diminished capability in close quarters combat."
	modifier_type = /datum/modifier/trait/wimpy
	mutually_exclusive = list(/datum/trait/modifier/physical/weak)


/datum/trait/modifier/physical/inaccurate
	name = "Inaccurate"
	desc = "You're rather inexperienced with guns, you've never used one in your life, or you're just really rusty.  \
	Regardless, you find it quite difficult to land shots where you wanted them to go."
	modifier_type = /datum/modifier/trait/inaccurate

/datum/trait/modifier/physical/shorter
	name = "Shorter"
	modifier_type = /datum/modifier/trait/shorter
	mutually_exclusive = list(/datum/trait/modifier/physical/short, /datum/trait/modifier/physical/tall, /datum/trait/modifier/physical/taller)

/datum/trait/modifier/physical/short
	name = "Short"
	modifier_type = /datum/modifier/trait/short
	mutually_exclusive = list(/datum/trait/modifier/physical/shorter, /datum/trait/modifier/physical/tall, /datum/trait/modifier/physical/taller)

/datum/trait/modifier/physical/tall
	name = "Tall"
	modifier_type = /datum/modifier/trait/tall
	mutually_exclusive = list(/datum/trait/modifier/physical/shorter, /datum/trait/modifier/physical/short, /datum/trait/modifier/physical/taller)

/datum/trait/modifier/physical/taller
	name = "Taller"
	modifier_type = /datum/modifier/trait/taller
	mutually_exclusive = list(/datum/trait/modifier/physical/shorter, /datum/trait/modifier/physical/short, /datum/trait/modifier/physical/tall)

/datum/trait/modifier/physical/thin
	name = "Thin"
	modifier_type = /datum/modifier/trait/thin
	mutually_exclusive = list(/datum/trait/modifier/physical/fat, /datum/trait/modifier/physical/obese, /datum/trait/modifier/physical/thinner)

/datum/trait/modifier/physical/thinner
	name = "Rail Thin"
	modifier_type = /datum/modifier/trait/thinner
	mutually_exclusive = list(/datum/trait/modifier/physical/fat, /datum/trait/modifier/physical/obese, /datum/trait/modifier/physical/thin)

/datum/trait/modifier/physical/fat
	name = "Broad-Shouldered"
	modifier_type = /datum/modifier/trait/fat
	mutually_exclusive = list(/datum/trait/modifier/physical/thin, /datum/trait/modifier/physical/obese, /datum/trait/modifier/physical/thinner)

/datum/trait/modifier/physical/obese
	name = "Heavily Built"
	modifier_type = /datum/modifier/trait/obese
	mutually_exclusive = list(/datum/trait/modifier/physical/fat, /datum/trait/modifier/physical/thinner, /datum/trait/modifier/physical/thin)

/datum/trait/modifier/physical/colorblind_protanopia
	name = "Protanopia"
	desc = "You have a form of red-green colorblindness. You cannot see reds, and have trouble distinguishing them from yellows and greens."
	modifier_type = /datum/modifier/trait/colorblind_protanopia
	mutually_exclusive = list(/datum/trait/modifier/physical/colorblind_deuteranopia, /datum/trait/modifier/physical/colorblind_tritanopia, /datum/trait/modifier/physical/colorblind_monochrome)

/datum/trait/modifier/physical/colorblind_deuteranopia
	name = "Deuteranopia"
	desc = "You have a form of red-green colorblindness. You cannot see greens, and have trouble distinguishing them from yellows and reds."
	modifier_type = /datum/modifier/trait/colorblind_deuteranopia
	mutually_exclusive = list(/datum/trait/modifier/physical/colorblind_protanopia, /datum/trait/modifier/physical/colorblind_tritanopia, /datum/trait/modifier/physical/colorblind_monochrome)

/datum/trait/modifier/physical/colorblind_tritanopia
	name = "Tritanopia"
	desc = "You have a form of blue-yellow colorblindness. You have trouble distinguishing between blues, greens, and yellows, and see blues and violets as dim."
	modifier_type = /datum/modifier/trait/colorblind_tritanopia
	mutually_exclusive = list(/datum/trait/modifier/physical/colorblind_protanopia, /datum/trait/modifier/physical/colorblind_deuteranopia, /datum/trait/modifier/physical/colorblind_monochrome)

/datum/trait/modifier/physical/colorblind_monochrome
	name = "Monochromacy"
	desc = "You are fully colorblind. Your condition is rare, but you can see no colors at all."
	modifier_type = /datum/modifier/trait/colorblind_monochrome
	mutually_exclusive = list(/datum/trait/modifier/physical/colorblind_protanopia, /datum/trait/modifier/physical/colorblind_deuteranopia, /datum/trait/modifier/physical/colorblind_tritanopia)

// These two traits might be borderline, feel free to remove if they get abused.
/datum/trait/modifier/physical/high_metabolism
	name = "High Metabolism"
	modifier_type = /datum/modifier/trait/high_metabolism
	mutually_exclusive = list(/datum/trait/modifier/physical/low_metabolism)

/datum/trait/modifier/physical/high_metabolism/test_for_invalidity(var/datum/category_item/player_setup_item/traits/setup)
	if(setup.is_FBP())
		return "Full Body Prosthetics do not have a metabolism."
	return ..()


/datum/trait/modifier/physical/low_metabolism
	name = "Low Metabolism"
	modifier_type = /datum/modifier/trait/low_metabolism
	mutually_exclusive = list(/datum/trait/modifier/physical/high_metabolism)

/datum/trait/modifier/physical/low_metabolism/test_for_invalidity(var/datum/category_item/player_setup_item/traits/setup)
	if(setup.is_FBP())
		return "Full Body Prosthetics do not have a metabolism."
	return ..()


/datum/trait/modifier/physical/cloned
	name = "Cloned"
	desc = "At some point in your life, you died and were cloned."
	modifier_type = /datum/modifier/cloned

/datum/trait/modifier/physical/cloned/test_for_invalidity(var/datum/category_item/player_setup_item/traits/setup)
	if(setup.is_FBP())
		return "Full Body Prosthetics cannot be cloned."
	return ..()


/datum/trait/modifier/physical/no_clone
	name = "Cloning Incompatability"
	modifier_type = /datum/modifier/no_clone

/datum/trait/modifier/physical/no_clone/test_for_invalidity(var/datum/category_item/player_setup_item/traits/setup)
	if(setup.is_FBP())
		return "Full Body Prosthetics cannot be cloned anyways."
	return ..()


/datum/trait/modifier/physical/no_borg
	name = "Cybernetic Incompatability"
	modifier_type = /datum/modifier/no_borg

/datum/trait/modifier/physical/no_borg/test_for_invalidity(var/datum/category_item/player_setup_item/traits/setup)
	if(setup.is_FBP())
		return "Full Body Prosthetics are already partly or fully mechanical."
	return ..()



// 'Mental' traits are just those that only sapients can have, for now, and generally involves fears.
// So far, all of them are just for fluff/don't have mechanical effects.
/datum/trait/modifier/mental
	category = "Mental"

/datum/trait/modifier/mental/test_for_invalidity(var/datum/category_item/player_setup_item/traits/setup)
	if(setup.is_FBP())
		if(setup.get_FBP_type() == PREF_FBP_SOFTWARE)
			return "Drone Intelligences cannot feel emotions."
	return ..()


/datum/trait/modifier/mental/arachnophobe
	name = "Arachnophobic"
	desc = "Spiders are quite creepy to most people, however for you, those chitters of pure evil inspire pure dread and fear."
	modifier_type = /datum/modifier/trait/phobia/arachnophobe


/datum/trait/modifier/mental/nyctophobe
	name = "Nyctophobic"
	desc = "More commonly known as the fear of darkness.  The shadows can hide many dangers, which makes the prospect of going into the depths of Maintenance rather worrisome."
	modifier_type = /datum/modifier/trait/phobia/nyctophobe


/datum/trait/modifier/mental/haemophobe
	name = "Haemophobia"
	desc = "Not to be confused with Haemophilia (which makes you bleed faster), Haemophobia is the fear of blood.  Seeing a bunch of blood isn't really \
	pleasant for most people, but for you, it is very distressing."
	modifier_type = /datum/modifier/trait/phobia/haemophobia


/datum/trait/modifier/mental/claustrophobe
	name = "Claustrophobic"
	desc = "Small spaces and tight quarters makes you feel distressed.  Unfortunately both are rather common when living in space."
	modifier_type = /datum/modifier/trait/phobia/claustrophobe


/datum/trait/modifier/mental/blennophobe
	name = "Blennophobia"
	desc = "Slimes are quite dangerous, but just the aspect of something being slimey is uncomfortable."
	modifier_type = /datum/modifier/trait/phobia/blennophobe

/datum/trait/modifier/mental/trypanophobe
	name = "Trypanophobia"
	desc = "Syringes and needles make you very distressed. You really don't want to get sick..."
	modifier_type = /datum/modifier/trait/phobia/trypanophobe

/*
// Uncomment this when/if these get finished.
/datum/trait/modifier/mental/synthphobe
	name = "Synthphobic"
	desc = "You know, deep down, that synthetics cannot be trusted, and so you are always on guard whenever you see one wandering around.  No one knows how a Positronic's mind works, \
	Drones are just waiting for the right time for Emergence, and the poor brains trapped in the cage of Man Machine Interfaces are now soulless, despite being unaware of it.  None \
	can be trusted."

/datum/trait/modifier/mental/xenophobe
	name = "Xenophobic"
	desc = "The mind of the Alien is unknowable, and as such, their intentions cannot be known.  You always watch the xenos closely, as they most certainly are watching you \
	closely, waiting to strike."
	mutually_exclusive = list(
		/datum/trait/modifier/mental/humanphobe,
		/datum/trait/modifier/mental/skrellphobe,
		/datum/trait/modifier/mental/tajaraphobe,
		/datum/trait/modifier/mental/unathiphobe,
		/datum/trait/modifier/mental/teshariphobe,
		/datum/trait/modifier/mental/prometheanphobe
	)

/datum/trait/modifier/mental/humanphobe
	name = "Human-phobic"
	desc = "Boilerplate racism for monkeys goes here."
	mutually_exclusive = list(/datum/trait/modifier/mental/xenophobe)

/datum/trait/modifier/mental/skrellphobe
	name = "Skrell-phobic"
	desc = "Boilerplate racism for squid goes here."
	mutually_exclusive = list(/datum/trait/modifier/mental/xenophobe)

/datum/trait/modifier/mental/tajaraphobe
	name = "Tajaran-phobic"
	desc = "Boilerplate racism for cats goes here."
	mutually_exclusive = list(/datum/trait/modifier/mental/xenophobe)

/datum/trait/modifier/mental/unathiphobe
	name = "Unathi-phobic"
	desc = "Boilerplate racism for lizards goes here."
	mutually_exclusive = list(/datum/trait/modifier/mental/xenophobe)

// Not sure why anyone would hate/fear these guys but for the sake of completeness here we are.
/datum/trait/modifier/mental/dionaphobe
	name = "Diona-phobic"
	desc = "Boilerplate racism for trees goes here."
	mutually_exclusive = list(/datum/trait/modifier/mental/xenophobe)

/datum/trait/modifier/mental/teshariphobe
	name = "Teshari-phobic"
	desc = "Boilerplate racism for birds goes here."
	mutually_exclusive = list(/datum/trait/modifier/mental/xenophobe)

/datum/trait/modifier/mental/prometheanphobe
	name = "Promethean-phobic"
	desc = "Boilerplate racism for jellos goes here."
	mutually_exclusive = list(/datum/trait/modifier/mental/xenophobe)
*/
