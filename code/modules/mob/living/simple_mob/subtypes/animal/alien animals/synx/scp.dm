////////////////////////////////////////////////////////////////////////////
//////////////////////////NOT A SYNX///////but acts kinda like one/////////
////////////////////////////////////////////////////////////////////////////
/*
Content relating to the SCP Foundation, including the SCP Foundation logo, is licensed under
Creative Commons Sharealike 3.0 and all concepts originate from http://www.scp-wiki.net and its authors.
This includes the sprites of the below Mob which are based upon SCP 939.
*/
//SCP-939
//sprites to be made.
/datum/ai_holder/simple_mob/scp
	hostile = TRUE // The majority of simplemobs are hostile.
	retaliate = TRUE	// The majority of simplemobs will fight back.
	cooperative = TRUE
	returns_home = FALSE
	can_flee = TRUE
	speak_chance = 0 // If the mob's saylist is empty, nothing will happen.
	wander = TRUE
	base_wander_delay = 3
	autopilot = TRUE //As the ghost in this shell you only control the voices.
	wander_when_pulled = TRUE
	outmatched_threshold = 100 //pussy
	flee_when_outmatched = TRUE
	call_distance = 100
	mauling = FALSE
	vision_range = 10 //no kiting, they have ears.
	use_astar = TRUE //Clever boy!
	threaten = TRUE

/mob/living/simple_mob/animal/synx/scp
	name = "Unknown"
	desc = "It's a red canine looking creature."
	tt_desc = "Unknown Alien Lifeform"

	poison_chance = 0 //no poison,
	ai_holder_type = /datum/ai_holder/simple_mob/scp
	say_list_type = /datum/say_list/malf_drone

	icon = 'icons/mob/synxmanyvoices.dmi'
	icon_state = "939_living"
	icon_living = "939_living"
	icon_dead = "939_dead"
	pixel_x = -15
